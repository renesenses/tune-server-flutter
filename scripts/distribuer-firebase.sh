#!/usr/bin/env bash
#
# Distribue UN APK arm64-v8a aux testeurs Firebase — et rien d'autre.
# renesenses/tune-server-universal#73.
#
#   scripts/distribuer-firebase.sh <app-arm64-v8a-release.apk> "<notes>"
#
# Pourquoi : la 0.9.147 a été téléversée à la main en trois APK
# (`--split-per-abi`), x86_64 en dernier. Firebase appelle « Latest » le
# dernier fichier téléversé, pas celui qui convient à l'appareil : Levente,
# sur un téléphone ARM, a appuyé sur Install et obtenu une erreur. Un testeur
# sur deux essayait d'abord la mauvaise variante.
#
# La release CI (`release.yml`) ne distribuait déjà que l'arm64 ; c'est le
# chemin manuel qui ne gardait rien. Ce script le garde :
#   - un seul APK par appel ;
#   - refus si l'APK embarque x86_64 ou armeabi-v7a, ou n'embarque pas
#     arm64-v8a (lu dans l'APK lui-même, pas dans son nom) ;
#   - refus des notes contenant un guillemet droit (« Too many arguments ») ;
#   - groupe `tune-béta-testeurs` toujours passé (sans lui : remis à personne) ;
#   - échec si la CLI échoue OU si elle n'écrit pas la ligne de succès de la
#     distribution (elle peut sortir en code 0 sur un 404 du groupe).
#
# armeabi-v7a (appareils d'avant 2015) et x86_64 (émulateurs) restent
# construits et attachés à la release GitHub ; ils ne vont plus sur Firebase.
#
# Variables : FIREBASE_ANDROID_APP_ID (défaut : Tune Android, com.mozaiklabs.tune),
#             FIREBASE_BIN (défaut : firebase), FIREBASE_TOKEN (facultatif).

set -uo pipefail

refus() { echo "REFUS : $*" >&2; exit 1; }

[ "$#" -eq 2 ] || refus "UN seul APK par appel, suivi des notes de version.
       usage : distribuer-firebase.sh <app-arm64-v8a-release.apk> \"<notes>\""
apk="$1"; notes="$2"

[ -f "$apk" ] || refus "APK introuvable : $apk"
case "$notes" in *'"'*) refus "les notes contiennent un guillemet droit : utiliser « »." ;; esac

abis="$(unzip -Z1 "$apk" 2>/dev/null | sed -n -E 's#^lib/([^/]+)/.*#\1#p' | sort -u)"
for interdite in x86_64 x86 armeabi-v7a armeabi; do
    grep -qx "$interdite" <<<"$abis" && refus "l'APK embarque $interdite.
       Firebase afficherait cet APK « Latest » aux téléphones ARM 64 bits.
       Distribuer build/app/outputs/flutter-apk/app-arm64-v8a-release.apk."
done
grep -qx arm64-v8a <<<"$abis" || refus "l'APK n'embarque pas de bibliothèque arm64-v8a."

app_id="${FIREBASE_ANDROID_APP_ID:-1:859451012274:android:363491697a5c0d96d585ab}"
firebase="${FIREBASE_BIN:-firebase}"
journal="$(mktemp)"
trap 'rm -f "$journal"' EXIT

args=(appdistribution:distribute "$apk" --app "$app_id"
      --groups "tune-béta-testeurs" --release-notes "$notes")
[ -n "${FIREBASE_TOKEN:-}" ] && args+=(--token "$FIREBASE_TOKEN")

"$firebase" "${args[@]}" 2>&1 | tee "$journal"
rc=${PIPESTATUS[0]}
[ "$rc" -eq 0 ] || refus "la CLI firebase a échoué (code $rc)."
grep -q "distributed to testers/groups successfully" "$journal" \
    || refus "APK téléversé mais NON distribué aux testeurs (groupe introuvable ?)."

echo "Distribué : $apk (arm64-v8a) → tune-béta-testeurs"
