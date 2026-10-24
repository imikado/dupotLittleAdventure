#!/bin/bash
# Exporte Little Adventure pour Linux (preset « Linux ») et construit
# export/linux/bundle.tar.gz, l'archive à attacher à la release GitHub
# utilisée par le manifeste Flathub (org.dupot.littleadventure) :
#   bundle/littleAdventure.x86_64
#   bundle/littleAdventure.pck
#
# Usage : ./build_flathub.sh [version]   (ex. ./build_flathub.sh 1.21.2)
# Sans argument, la version est lue dans globalVersion.gd.
set -e

cd "$(dirname "$0")"

GODOT="${GODOT:-$(command -v godot || echo "$HOME/apps/Godot_v4.7.2-stable_linux.x86_64")}"
PRESET="Linux"
LINUX_DIR="export/linux"
BUNDLE_DIR="$LINUX_DIR/bundle"
ARCHIVE="$LINUX_DIR/bundle.tar.gz"
APPDATA_FILE="$LINUX_DIR/flatpak/org.dupot.littleadventure.appdata.xml"
VERSION_FILE="common/singletons/globalVersion.gd"

if [ ! -x "$GODOT" ]; then
	echo "Godot introuvable ($GODOT) : définir la variable GODOT" >&2
	exit 1
fi

# Les modèles d'export Linux doivent correspondre à la version de Godot
GODOT_VERSION="$("$GODOT" --version | sed "s/\.official.*//")"
TEMPLATES="$HOME/.local/share/godot/export_templates/$GODOT_VERSION"
if [ ! -f "$TEMPLATES/linux_release.x86_64" ]; then
	echo "Modèles d'export Linux absents pour Godot $GODOT_VERSION ($TEMPLATES)" >&2
	exit 1
fi

# Version du jeu reprise de l'appdata
./maj_version.sh

VERSION="${1:-$(grep -m1 "version" "$VERSION_FILE" | grep -oE "[0-9]+(\.[0-9]+)+")}"
if [ -z "$VERSION" ]; then
	echo "Version introuvable dans $VERSION_FILE" >&2
	exit 1
fi

# Flathub refuse une version sans entrée <release> dans l'appdata
if ! grep -q "version=\"$VERSION\"" "$APPDATA_FILE"; then
	echo "Attention : aucune <release version=\"$VERSION\"> dans $APPDATA_FILE" >&2
fi

# Godot ne doit pas importer (ni embarquer dans le .pck) les contenus de
# publication déjà rangés sous export/ : captures, icônes et builds.
mkdir -p export
touch export/.gdignore

rm -rf "$BUNDLE_DIR" "$ARCHIVE"
mkdir -p "$BUNDLE_DIR"

# Import des ressources puis export avec la version de Godot du projet.
# Le nom du binaire fixe celui du .pck : le manifeste attend littleAdventure.*
"$GODOT" --headless --path . --import
"$GODOT" --headless --path . --export-release "$PRESET" "$BUNDLE_DIR/littleAdventure.x86_64"

for f in "$BUNDLE_DIR/littleAdventure.x86_64" "$BUNDLE_DIR/littleAdventure.pck"; do
	if [ ! -f "$f" ]; then
		echo "Échec de l'export ($f)" >&2
		exit 1
	fi
done
chmod 755 "$BUNDLE_DIR/littleAdventure.x86_64"
chmod 644 "$BUNDLE_DIR/littleAdventure.pck"

# Le manifeste extrait l'archive avec strip-components=1 : tout doit être
# sous un unique dossier racine bundle/
tar -C "$LINUX_DIR" --owner=0 --group=0 --numeric-owner \
	-czf "$ARCHIVE" bundle/littleAdventure.x86_64 bundle/littleAdventure.pck

SHA256="$(sha256sum "$ARCHIVE" | cut -d" " -f1)"

echo "Version : $VERSION"
echo "Archive : $ARCHIVE ($(du -h "$ARCHIVE" | cut -f1))"
echo "SHA256  : $SHA256"
echo
echo "Attacher $ARCHIVE à la release $VERSION, puis dans le manifeste Flathub :"
echo "  url: https://github.com/imikado/dupotLittleAdventure/releases/download/$VERSION/bundle.tar.gz"
echo "  sha256: $SHA256"
