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
# déclarée (aujourd'hui dans `tune-engine.version`). Il est appelé par la CI, par la release et par
# `preBuild` de Gradle : aucun APK ne peut donc sortir avec un moteur périmé.
#
# Depuis l'application « Tune serveur » (09/10/2026), l'interface vient de la
# télécommande (`tune-remote-flutter`) et n'a plus le numéro de version du
# moteur : la version ATTENDUE des `.so` n'est donc plus lue dans
# `pubspec.yaml` mais dans `tune-engine.version`, à la racine du dépôt. C'est
# le tag de `tune-server-rust` dont la bibliothèque est construite. Seule
# l'ABI arm64-v8a est livrée (l'émulateur ARM64 du Mac comme les téléphones).
#
# Usage :
#   scripts/check-native-libs.sh            # vérifie (code de sortie 1 si dérive)
#   scripts/check-native-libs.sh --update   # régénère l'empreinte après un rebuild
#
# `--update` refuse d'écrire l'empreinte si un `.so` ne porte pas la version
# attendue : un build cassé ne peut donc pas se faire tamponner « à jour ».

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

JNI_DIR="$REPO_ROOT/android/app/src/main/jniLibs"
MANIFEST="$JNI_DIR/tune-native.manifest"
ENGINE_VERSION_FILE="$REPO_ROOT/tune-engine.version"

# arm64 seulement : les .so v7a (24 Mo) et x86_64 (42 Mo) ne servaient qu'aux
# vieux téléphones 32 bits et à l'émulateur x86. Gradle filtre les ABI
# (`abiFilters` dans android/app/build.gradle.kts) : l'APK ne s'installe pas
# là où la bibliothèque manquerait.
ABIS="arm64-v8a"

MODE="check"
if [ "${1:-}" = "--update" ]; then
    MODE="update"
elif [ -n "${1:-}" ]; then
    echo "ERREUR : argument inconnu « $1 » (attendu : --update ou rien)" >&2
    exit 2
fi

fail() {
    echo "" >&2
    echo "❌ BIBLIOTHÈQUES NATIVES PÉRIMÉES — build interrompu (issue #1751)" >&2
    echo "" >&2
    while [ "$#" -gt 0 ]; do
        echo "   $1" >&2
        shift
    done
    echo "" >&2
    echo "   Pour repartir d'un état sain :" >&2
    echo "     1. dans tune-server-rust, au tag de tune-engine.version :" >&2
    echo "        cargo build -p tune-ffi --target aarch64-linux-android --release" >&2
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

[ -f "$ENGINE_VERSION_FILE" ] || { echo "ERREUR : $ENGINE_VERSION_FILE introuvable" >&2; exit 2; }

# Première ligne non vide et non commentée : `1.0.0-rc3`.
WANT_VERSION="$(grep -v -E '^[[:space:]]*(#|$)' "$ENGINE_VERSION_FILE" | head -1 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
if [ -z "$WANT_VERSION" ]; then
    echo "ERREUR : version illisible dans $ENGINE_VERSION_FILE" >&2
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
        echo "# Toute dérive entre cette empreinte et tune-engine.version fait ÉCHOUER le build (#1751)."
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
    fail "tune-engine.version attend le moteur $WANT_VERSION," \
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

echo "Bibliothèques natives conformes : v$WANT_VERSION ($ABIS)."
