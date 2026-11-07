#!/bin/bash
# Exporte Little Adventure pour Flathub : génère le .pck seul (preset « Linux »,
# le moteur est fourni par org.godotengine.godot.BaseApp) puis crée
# export/linux/bundle.tar.gz, l'archive à attacher à la release GitHub
# utilisée par le manifeste Flathub (org.dupot.littleadventure) :
#   bundle/littleAdventure.pck
#   bundle/icons/*.png
#   bundle/org.dupot.littleadventure.appdata.xml
#   bundle/org.dupot.littleadventure.desktop
#
# Usage : ./export_flathub.sh   (appelé par update_release.py du dépôt Flathub)
set -e

cd "$(dirname "$0")"

GODOT="${GODOT:-$(command -v godot || echo "$HOME/apps/Godot_v4.7.2-stable_linux.x86_64")}"
PRESET="Linux"
APP_ID="org.dupot.littleadventure"
LINUX_DIR="export/linux"
FLATPAK_DIR="$LINUX_DIR/flatpak"
APPDATA="$FLATPAK_DIR/$APP_ID.appdata.xml"
DESKTOP="$FLATPAK_DIR/$APP_ID.desktop"
ICON_SIZES="16 24 32 48 64 128 256 512"
PCK="$LINUX_DIR/bundle/littleAdventure.pck"
ARCHIVE="$LINUX_DIR/bundle.tar.gz"

if [ ! -x "$GODOT" ]; then
	echo "Godot introuvable ($GODOT) : définir la variable GODOT" >&2
	exit 1
fi

for f in "$APPDATA" "$DESKTOP"; do
	if [ ! -f "$f" ]; then
		echo "Fichier manquant : $f" >&2
		exit 1
	fi
done
for size in $ICON_SIZES; do
	if [ ! -f "$FLATPAK_DIR/${size}x${size}.png" ]; then
		echo "Icône manquante : $FLATPAK_DIR/${size}x${size}.png" >&2
		exit 1
	fi
done

# Version du jeu reprise de l'appdata (project.godot, globalVersion.gd, snap)
./update_version.sh

# Les captures référencées par l'appdata doivent exister sur GitHub
# (./update_screenshots_appdata.sh pour pointer sur un commit poussé)
SCREENSHOTS_COMMIT="$(grep -m1 -oP 'raw\.githubusercontent\.com/[^/]+/[^/]+/\K[0-9a-f]{40}' "$APPDATA" || true)"
if [ -z "$SCREENSHOTS_COMMIT" ]; then
	echo "Attention : captures de l'appdata sans commit fixe (./update_screenshots_appdata.sh)" >&2
elif [ -z "$(git branch -r --contains "$SCREENSHOTS_COMMIT" 2>/dev/null)" ]; then
	echo "Attention : le commit $SCREENSHOTS_COMMIT des captures n'est pas poussé" >&2
fi

# Godot ne doit pas importer (ni embarquer dans le .pck) les contenus de
# publication déjà rangés sous export/ : captures, icônes et builds.
mkdir -p export
touch export/.gdignore

# Import des ressources puis export du .pck seul
mkdir -p "$(dirname "$PCK")"
rm -f "$PCK"
"$GODOT" --headless --path . --import
"$GODOT" --headless --path . --export-pack "$PRESET" "$PCK"

if [ ! -f "$PCK" ]; then
	echo "Échec de l'export du pck ($PCK)" >&2
	exit 1
fi

# Vérification des métadonnées (facultative, si les outils sont installés)
if command -v appstreamcli >/dev/null; then
	appstreamcli validate --no-net "$APPDATA" || true
fi
if command -v desktop-file-validate >/dev/null; then
	desktop-file-validate "$DESKTOP" || true
fi

# Bundle, assemblé dans un dossier temporaire. Le manifeste extrait l'archive
# avec strip-components=1 : tout doit être sous un unique dossier racine bundle/
STAGING="$(mktemp -d)"
trap 'rm -rf "$STAGING"' EXIT
mkdir -p "$STAGING/bundle/icons"
install -m644 "$PCK" "$STAGING/bundle/"
for size in $ICON_SIZES; do
	install -m644 "$FLATPAK_DIR/${size}x${size}.png" "$STAGING/bundle/icons/"
done
install -m644 "$APPDATA" "$DESKTOP" "$STAGING/bundle/"

rm -f "$ARCHIVE"
tar -C "$STAGING" --sort=name --owner=0 --group=0 --numeric-owner \
	-czf "$ARCHIVE" bundle

VERSION="$(grep -m1 -oP '<release\b[^>]*\bversion="\K[^"]+' "$APPDATA")"
echo "Version : $VERSION"
echo "Pck     : $PCK ($(du -h "$PCK" | cut -f1))"
echo "Archive : $ARCHIVE ($(du -h "$ARCHIVE" | cut -f1))"
echo "SHA256  : $(sha256sum "$ARCHIVE" | cut -d' ' -f1)"
echo
echo "Attacher $ARCHIVE à la release $VERSION sur GitHub, puis lancer"
echo "update_release.py --no-export dans le dépôt Flathub."
