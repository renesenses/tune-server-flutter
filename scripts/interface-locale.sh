#!/usr/bin/env bash
#
# Pointe la dépendance `tune_remote` sur une copie LOCALE de
# tune-remote-flutter, pour les machines qui n'ont pas d'accès git au dépôt
# privé (Shrek). Écrit `pubspec_overrides.yaml`, que git ignore.
#
# La copie DOIT être au commit épinglé dans pubspec.yaml (`ref:`) : sinon on
# testerait une autre interface que celle qui sera livrée. Le script le
# vérifie, par `git rev-parse HEAD` si la copie est un dépôt, sinon par le
# fichier `.tune-remote-ref` qu'y dépose l'extraction :
#
#   git -C ../tune-remote-flutter archive <ref> | tar -x -C /tmp/tune-remote
#   echo <ref> > /tmp/tune-remote/.tune-remote-ref
#   scripts/interface-locale.sh /tmp/tune-remote
#
# Sans argument : retire la surcharge (retour à la dépendance git).

set -euo pipefail
RACINE="$(cd "$(dirname "$0")/.." && pwd)"
SURCHARGE="$RACINE/pubspec_overrides.yaml"

if [ -z "${1:-}" ]; then
    rm -f "$SURCHARGE"
    echo "Surcharge retirée : tune_remote vient de git."
    exit 0
fi

COPIE="$(cd "$1" && pwd)"
ATTENDU="$(awk '/^  tune_remote:/{f=1} f && /ref:/{print $2; exit}' "$RACINE/pubspec.yaml")"
[ -n "$ATTENDU" ] || { echo "ERREUR : ref de tune_remote illisible dans pubspec.yaml" >&2; exit 2; }

if [ -d "$COPIE/.git" ] || git -C "$COPIE" rev-parse --git-dir >/dev/null 2>&1; then
    TROUVE="$(git -C "$COPIE" rev-parse HEAD)"
else
    TROUVE="$(cat "$COPIE/.tune-remote-ref" 2>/dev/null || true)"
fi
if [ "$TROUVE" != "$ATTENDU" ]; then
    echo "ERREUR : la copie $COPIE est à « ${TROUVE:-inconnu} »," >&2
    echo "         pubspec.yaml épingle tune_remote à $ATTENDU." >&2
    exit 1
fi

cat > "$SURCHARGE" <<YAML
# Écrit par scripts/interface-locale.sh — jamais versionné.
# Copie locale de tune-remote-flutter au commit $ATTENDU.
dependency_overrides:
  tune_remote:
    path: $COPIE
YAML
echo "tune_remote → $COPIE ($ATTENDU)"
