#!/usr/bin/env bash
#
# Garde-fou « bibliothèques natives périmées » — issue #1751.
#
# Le 15/08/2026 on a découvert que les trois `libtuneserver.so` embarqués dans
# l'APK Android dataient de rust v0.8.354 (21 juillet) alors que le serveur
# était en 0.9.76 : les testeurs Android ont tourné trois semaines et demie sur
# un moteur périmé à l'intérieur d'une interface récente, sans que rien ne le
# signale. Le script de reconstruction (`tune-ffi/build-android.sh`) masquait le
# code de sortie de cargo et recopiait alors la bibliothèque du build précédent.
#
# Ce script rend l'accident impossible côté distribution : il échoue — il
# n'avertit pas — dès que les `.so` embarqués ne correspondent plus à la version
# déclarée dans `pubspec.yaml`. Il est appelé par la CI, par la release et par
# `preBuild` de Gradle : aucun APK ne peut donc sortir avec un moteur périmé.
#
# Usage :
#   scripts/check-native-libs.sh            # vérifie (code de sortie 1 si dérive)
#   scripts/check-native-libs.sh --update   # régénère l'empreinte après un rebuild
#   scripts/check-native-libs.sh --staged   # vérifie le PROCHAIN COMMIT (index)
#
# `--update` refuse d'écrire l'empreinte si un `.so` ne porte pas la version
# attendue : un build cassé ne peut donc pas se faire tamponner « à jour ».
#
# `--staged` juge l'index et non la copie de travail : c'est ce que le hook
# `pre-commit` appelle pour qu'un commit de bump ne puisse pas exister sans les
# `.so` reconstruits. Constater la dérive après coup ne suffisait pas — sur
# 0.9.81, 0.9.85, 0.9.89, 0.9.90 et 0.9.91, le commit de bump a laissé la CI
# rouge et il a fallu un second commit de reconstruction pour la repasser au
# vert. Ici la dérive n'existe jamais : le commit est refusé.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# TUNE_CHECK_ROOT : arborescence à inspecter quand elle n'est pas la copie de
# travail — c'est ainsi que `--staged` se relance sur le contenu de l'index.
REPO_ROOT="${TUNE_CHECK_ROOT:-$(cd "$SCRIPT_DIR/.." && pwd)}"

JNI_DIR="$REPO_ROOT/android/app/src/main/jniLibs"
MANIFEST="$JNI_DIR/tune-native.manifest"
PUBSPEC="$REPO_ROOT/pubspec.yaml"

ABIS="arm64-v8a armeabi-v7a x86_64"

MODE="check"
case "${1:-}" in
    "")        MODE="check" ;;
    --update)  MODE="update" ;;
    --staged)  MODE="staged" ;;
    *)
        echo "ERREUR : argument inconnu « $1 » (attendu : --update, --staged ou rien)" >&2
        exit 2
        ;;
esac

# ------------------------------------------------------------------- --staged
#
# On matérialise le contenu de l'INDEX dans une arborescence jetable, puis on se
# relance dessus en mode `check`. L'index — pas la copie de travail — est ce qui
# deviendra le commit : un `.so` reconstruit mais non ajouté doit être compté
# comme absent, sinon le hook validerait un commit que la CI refusera.
if [ "$MODE" = "staged" ]; then
    if ! command -v git >/dev/null 2>&1 || ! git -C "$REPO_ROOT" rev-parse --git-dir >/dev/null 2>&1; then
        echo "ERREUR : --staged exige un dépôt git" >&2
        exit 2
    fi

    STAGE_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/tune-native-staged.XXXXXX")"
    trap 'rm -rf "$STAGE_ROOT"' EXIT

    # `git ls-files --stage` ne liste QUE l'index. Un fichier supprimé de
    # l'index n'y figure plus : on le laisse absent, et la vérification échoue
    # comme elle le doit.
    materialiser() {
        REL="$1"
        if [ -z "$(git -C "$REPO_ROOT" ls-files --stage -- "$REL")" ]; then
            return 0
        fi
        mkdir -p "$STAGE_ROOT/$(dirname "$REL")"
        git -C "$REPO_ROOT" show ":$REL" > "$STAGE_ROOT/$REL"
    }

    materialiser "pubspec.yaml"
    materialiser "android/app/src/main/jniLibs/tune-native.manifest"
    for ABI in $ABIS; do
        materialiser "android/app/src/main/jniLibs/$ABI/libtuneserver.so"
    done

    STATUS=0
    TUNE_CHECK_ROOT="$STAGE_ROOT" "$SCRIPT_DIR/$(basename "$0")" || STATUS=$?
    exit "$STATUS"
fi

fail() {
    echo "" >&2
    echo "❌ BIBLIOTHÈQUES NATIVES PÉRIMÉES — build interrompu (issue #1751)" >&2
    echo "" >&2
    while [ "$#" -gt 0 ]; do
        echo "   $1" >&2
        shift
    done
    if [ -n "${TUNE_CHECK_ROOT:-}" ]; then
        echo "   (analyse du contenu de l'index : les chemins ci-dessus sont une" >&2
        echo "    copie jetable du prochain commit, pas votre copie de travail.)" >&2
        echo "" >&2
    fi
    echo "   Pour repartir d'un état sain :" >&2
    echo "     1. dans tune-server-rust : ./tune-ffi/build-android.sh --release" >&2
    echo "     2. ici                   : scripts/check-native-libs.sh --update" >&2
    echo "     3. committer les .so ET android/app/src/main/jniLibs/tune-native.manifest" >&2
    echo "" >&2
    exit 1
}

# sha256 portable : shasum sur macOS, sha256sum sur Linux.
sha256_of() {
    if command -v shasum >/dev/null 2>&1; then
        shasum -a 256 "$1" | awk '{print $1}'
    elif command -v sha256sum >/dev/null 2>&1; then
        sha256sum "$1" | awk '{print $1}'
    else
        echo "ERREUR : ni shasum ni sha256sum disponibles" >&2
        exit 2
    fi
}

# La version telle qu'elle est compilée dans le binaire (tune_core::version()
# est un littéral `env!("CARGO_PKG_VERSION")`, donc présent en clair dans le
# .rodata). `grep -a` évite de dépendre de `strings` (binutils absent de
# certaines images CI). `-q` s'arrête à la première occurrence : dix fois plus
# rapide que `-c` sur une bibliothèque de 40 Mo faite d'une seule « ligne ».
so_contains_version() {
    LC_ALL=C grep -a -q -F "$2" "$1"
}

[ -f "$PUBSPEC" ] || { echo "ERREUR : $PUBSPEC introuvable" >&2; exit 2; }

# `version: 0.9.76+497` → `0.9.76`. Le numéro de build (+N) ne concerne que les
# stores, pas le moteur natif.
WANT_VERSION="$(grep -E '^version:' "$PUBSPEC" | head -1 | sed -e 's/^version:[[:space:]]*//' -e 's/+.*$//' -e 's/[[:space:]]*$//')"
if [ -z "$WANT_VERSION" ]; then
    echo "ERREUR : version illisible dans $PUBSPEC" >&2
    exit 2
fi

if [ "$MODE" = "update" ]; then
    # Accolades obligatoires : bash 3.2 (macOS) avale le caractère multi-octets
    # qui suit et croit lire un nom de variable inconnu.
    echo "Régénération de l'empreinte pour la version ${WANT_VERSION}…"
    TMP_MANIFEST="$MANIFEST.tmp.$$"
    {
        echo "# Empreinte des bibliothèques natives embarquées (libtuneserver.so)."
        echo "# Générée par scripts/check-native-libs.sh --update — ne pas éditer à la main."
        echo "# Toute dérive entre cette empreinte et pubspec.yaml fait ÉCHOUER le build (#1751)."
        echo "version=$WANT_VERSION"
    } > "$TMP_MANIFEST"

    for ABI in $ABIS; do
        SO="$JNI_DIR/$ABI/libtuneserver.so"
        if [ ! -f "$SO" ]; then
            rm -f "$TMP_MANIFEST"
            fail "$ABI : $SO est absent — la reconstruction n'a pas produit de bibliothèque."
        fi
        if ! so_contains_version "$SO" "$WANT_VERSION"; then
            rm -f "$TMP_MANIFEST"
            fail "$ABI : la bibliothèque ne contient pas la version $WANT_VERSION." \
                 "Elle provient d'un build antérieur : cargo a échoué et l'ancien .so" \
                 "a été recopié. On refuse de tamponner « à jour » un binaire périmé."
        fi
        echo "$ABI=$(sha256_of "$SO")" >> "$TMP_MANIFEST"
        echo "  ✓ $ABI"
    done

    mv "$TMP_MANIFEST" "$MANIFEST"
    echo "Empreinte écrite : $MANIFEST (version $WANT_VERSION)"
    exit 0
fi

# ---------------------------------------------------------------- vérification

if [ ! -f "$MANIFEST" ]; then
    fail "L'empreinte $MANIFEST est absente." \
         "Sans elle on ne peut pas savoir de quelle version proviennent les .so."
fi

HAVE_VERSION="$(grep -E '^version=' "$MANIFEST" | head -1 | cut -d= -f2)"
if [ -z "$HAVE_VERSION" ]; then
    fail "L'empreinte $MANIFEST ne déclare aucune version."
fi

if [ "$HAVE_VERSION" != "$WANT_VERSION" ]; then
    fail "pubspec.yaml construit la version $WANT_VERSION," \
         "mais les bibliothèques natives embarquées sont celles de $HAVE_VERSION." \
         "C'est exactement l'accident du 15/08 : interface récente, moteur périmé."
fi

for ABI in $ABIS; do
    SO="$JNI_DIR/$ABI/libtuneserver.so"
    [ -f "$SO" ] || fail "$ABI : $SO est absent de l'arborescence."

    EXPECTED="$(grep -E "^$ABI=" "$MANIFEST" | head -1 | cut -d= -f2)"
    if [ -z "$EXPECTED" ]; then
        fail "$ABI : aucune empreinte sha256 dans $MANIFEST."
    fi

    ACTUAL="$(sha256_of "$SO")"
    if [ "$ACTUAL" != "$EXPECTED" ]; then
        fail "$ABI : la bibliothèque ne correspond pas à l'empreinte enregistrée." \
             "  attendu : $EXPECTED" \
             "  trouvé  : $ACTUAL" \
             "Un .so a été remplacé sans régénérer l'empreinte."
    fi

    # Deuxième verrou : l'empreinte seule ne prouve rien si quelqu'un la
    # régénère à la main. La version doit être présente dans le binaire.
    if ! so_contains_version "$SO" "$WANT_VERSION"; then
        fail "$ABI : la bibliothèque ne contient pas la chaîne de version $WANT_VERSION." \
             "Elle n'a pas été compilée depuis le serveur en cours de construction."
    fi

    echo "  ✓ $ABI — libtuneserver.so v$WANT_VERSION (${ACTUAL:0:16}…)"
done

echo "Bibliothèques natives conformes : v$WANT_VERSION sur les trois ABI."
