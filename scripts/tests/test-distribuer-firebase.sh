#!/usr/bin/env bash
#
# Tests de scripts/distribuer-firebase.sh (#73 de tune-server-universal).
# Aucun réseau : `firebase` est remplacé par un faux binaire (FIREBASE_BIN).
# Lancer : bash scripts/tests/test-distribuer-firebase.sh

set -u
ici="$(cd "$(dirname "$0")" && pwd)"
script="$ici/../distribuer-firebase.sh"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
echecs=0

apk() { # apk <nom> <abi>… — faux APK contenant lib/<abi>/libtuneserver.so
    d="$tmp/src-$1"; mkdir -p "$d"
    shift_nom="$1"; shift
    for abi in "$@"; do mkdir -p "$d/lib/$abi"; echo x > "$d/lib/$abi/libtuneserver.so"; done
    echo x > "$d/AndroidManifest.xml"
    (cd "$d" && zip -qr "$tmp/$shift_nom.apk" .)
}

# Faux firebase : note ses arguments, imite la sortie de la vraie CLI.
faux() { # faux <nom> <ligne de sortie> <code>
    cat > "$tmp/$1" <<SH
#!/usr/bin/env bash
printf '%s\n' "\$@" > "$tmp/$1.args"
echo "$2"
exit $3
SH
    chmod +x "$tmp/$1"
}
faux fb-ok "✔  [appdistribution] distributed to testers/groups successfully" 0
faux fb-404 "⚠  [appdistribution] failed to distribute to testers/groups: 404" 0
faux fb-ko "Error: upload failed" 1

apk arm64 arm64-v8a
apk x86 x86_64
apk v7 armeabi-v7a
apk fat arm64-v8a armeabi-v7a x86_64
apk vide

attendu() { # attendu <code> <motif> <nom> -- commande…
    code="$1"; motif="$2"; nom="$3"; shift 4
    sortie="$("$@" 2>&1)"; rc=$?
    if [ "$rc" -ne "$code" ] || { [ -n "$motif" ] && ! grep -q -- "$motif" <<<"$sortie"; }; then
        echo "ÉCHEC  $nom (code $rc, attendu $code, motif « $motif »)"; sed 's/^/        /' <<<"$sortie"
        echecs=$((echecs + 1)); return
    fi
    echo "ok     $nom"
}

export FIREBASE_ANDROID_APP_ID="1:0:android:test"

FIREBASE_BIN="$tmp/fb-ok" attendu 0 "" "APK arm64-v8a distribué" -- \
    bash "$script" "$tmp/arm64.apk" "Tune v0.9.150"
grep -qx -- "--groups" "$tmp/fb-ok.args" && grep -qx "tune-béta-testeurs" "$tmp/fb-ok.args" \
    && echo "ok     groupe des testeurs transmis" \
    || { echo "ÉCHEC  groupe des testeurs absent"; echecs=$((echecs + 1)); }

# Le cas de Levente : x86_64 téléversé, Firebase l'affiche « Latest ».
rm -f "$tmp/fb-ok.args"
FIREBASE_BIN="$tmp/fb-ok" attendu 1 "x86_64" "APK x86_64 refusé" -- bash "$script" "$tmp/x86.apk" "n"
[ ! -e "$tmp/fb-ok.args" ] && echo "ok     firebase jamais appelé pour x86_64" \
    || { echo "ÉCHEC  firebase appelé pour x86_64"; echecs=$((echecs + 1)); }

FIREBASE_BIN="$tmp/fb-ok" attendu 1 "armeabi-v7a" "APK armeabi-v7a refusé" -- bash "$script" "$tmp/v7.apk" "n"
FIREBASE_BIN="$tmp/fb-ok" attendu 1 "x86_64" "APK fat refusé" -- bash "$script" "$tmp/fat.apk" "n"
FIREBASE_BIN="$tmp/fb-ok" attendu 1 "arm64-v8a" "APK sans moteur natif refusé" -- bash "$script" "$tmp/vide.apk" "n"
FIREBASE_BIN="$tmp/fb-ok" attendu 1 "UN seul" "deux APK d'un coup refusés" -- \
    bash "$script" "$tmp/arm64.apk" "$tmp/x86.apk" "n"
FIREBASE_BIN="$tmp/fb-ok" attendu 1 "introuvable" "APK absent refusé" -- bash "$script" "$tmp/nul.apk" "n"
FIREBASE_BIN="$tmp/fb-ok" attendu 1 "guillemet" "notes avec guillemet droit refusées" -- \
    bash "$script" "$tmp/arm64.apk" 'tri "ajouté"'
FIREBASE_BIN="$tmp/fb-404" attendu 1 "testeurs" "404 sur le groupe en code 0 détecté" -- \
    bash "$script" "$tmp/arm64.apk" "n"
FIREBASE_BIN="$tmp/fb-ko" attendu 1 "" "échec de la CLI propagé" -- bash "$script" "$tmp/arm64.apk" "n"

echo
if [ "$echecs" -ne 0 ]; then echo "$echecs test(s) en échec."; exit 1; fi
echo "Tous les tests passent."
