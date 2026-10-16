#!/bin/zsh
# Tiroir — installation ou mise à jour, sans compte GitHub et sans outil à installer :
#   curl -fsSL https://raw.githubusercontent.com/LucasHRCHatReply/tiroir-releases/main/installer.sh | zsh
# Le script télécharge la dernière version publiée, vérifie l'empreinte SHA-256, l'identifiant et l'équipe de signature
# (codesign --verify --deep --strict), puis lance install.sh du zip : Tiroir.app va dans ~/Applications, la quarantaine est
# levée sur Tiroir.app seulement, l'app est lancée. Une instance de Tiroir
# qui tourne est quittée d'abord. Historique et réglages (~/Library/Application Support/Tiroir) ne sont jamais touchés.
# Aucun mot de passe administrateur. Le script se lit en entier avant de le lancer.
set -uo pipefail
ZIP_URL="${TIROIR_ZIP_URL:-https://github.com/LucasHRCHatReply/tiroir-releases/releases/latest/download/Tiroir.zip}"
TEAM="JT9FY7PP7K"
BUNDLE_ID="com.tiroir.app"
fail() { echo "\nÉCHEC : $*" >&2; exit 1; }
step() { echo "\n[$1/3] $2"; }

step 1 "Ce Mac convient-il ?"
macos=$(sw_vers -productVersion)
(( ${macos%%.*} >= 15 )) || fail "Tiroir demande macOS 15 ou plus (ce Mac : $macos)."
[[ "$(sysctl -n hw.optional.arm64 2>/dev/null)" == "1" ]] || fail "Tiroir ne tourne que sur les Mac à puce Apple (M1 ou plus récent)."
echo "  macOS $macos : ok"

step 2 "Téléchargement et contrôle"
WORK=$(mktemp -d "${TMPDIR:-/tmp}/tiroir-install.XXXXXX") || fail "dossier temporaire impossible"
trap 'rm -rf "$WORK"' EXIT
curl -fL --silent --show-error -o "$WORK/Tiroir.zip" "$ZIP_URL" || fail "téléchargement impossible (réseau coupé, ou aucune version publiée) : $ZIP_URL"
if curl -fL --silent -o "$WORK/Tiroir.zip.sha256" "$ZIP_URL.sha256" 2>/dev/null && [[ -s "$WORK/Tiroir.zip.sha256" ]]; then
  want=$(awk '{print $1; exit}' "$WORK/Tiroir.zip.sha256"); have=$(shasum -a 256 "$WORK/Tiroir.zip" | awk '{print $1}')
  [[ "$want" == "$have" ]] || fail "l'empreinte SHA-256 du zip ne correspond pas à celle publiée : installation refusée."
  echo "  empreinte SHA-256 : conforme"
else
  fail "l'empreinte SHA-256 publiée est introuvable : installation refusée."
fi
ditto -x -k "$WORK/Tiroir.zip" "$WORK/contenu" || fail "le zip est illisible"
DIR=$(ls -d "$WORK"/contenu/Tiroir-* 2>/dev/null | head -1)
[[ -n "$DIR" && -d "$DIR/Tiroir.app" && -f "$DIR/install.sh" ]] || fail "le zip n'a pas le contenu attendu (Tiroir-X.Y.Z/Tiroir.app et install.sh)."
[[ "$(/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' "$DIR/Tiroir.app/Contents/Info.plist" 2>/dev/null)" == "$BUNDLE_ID" ]] || fail "identifiant de l'app inattendu : installation refusée."
got=$(codesign -dv "$DIR/Tiroir.app" 2>&1 | sed -n 's/^TeamIdentifier=//p')
[[ "$got" == "$TEAM" ]] || fail "l'app n'est pas signée par l'équipe attendue ($TEAM) mais par « ${got:-aucune} » : installation refusée."
codesign --verify --deep --strict "$DIR/Tiroir.app" 2>/dev/null || fail "la signature de Tiroir.app est invalide : installation refusée."
NEW=$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$DIR/Tiroir.app/Contents/Info.plist")
echo "  Tiroir $NEW, signature valide, équipe $TEAM : ok  ($(du -h "$WORK/Tiroir.zip" | cut -f1))"

step 3 "Installation"
zsh "$DIR/install.sh" "$DIR/Tiroir.app" || fail "l'installation a échoué (voir le message ci-dessus)."
echo "\nTerminé."
