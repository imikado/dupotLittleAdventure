#!/bin/bash
# Exporte Little Adventure pour Linux (preset « Linux »), puis construit le
# snap avec snapcraft dans export/linux/snap.
set -e

cd "$(dirname "$0")"

GODOT="${GODOT:-$(command -v godot || echo "$HOME/apps/Godot_v4.7.2-stable_linux.x86_64")}"
PRESET="Linux"
SNAP_DIR="export/linux/snap"
SNAPCRAFT_FILE="$SNAP_DIR/snap/snapcraft.yaml"

if [ ! -x "$GODOT" ]; then
	echo "Godot introuvable ($GODOT) : définir la variable GODOT" >&2
	exit 1
fi

if ! command -v snapcraft > /dev/null; then
	echo "snapcraft introuvable : sudo snap install snapcraft --classic" >&2
	exit 1
fi

# Les modèles d'export Linux doivent correspondre à la version de Godot
GODOT_VERSION="$("$GODOT" --version | sed "s/\.official.*//")"
TEMPLATES="$HOME/.local/share/godot/export_templates/$GODOT_VERSION"
if [ ! -f "$TEMPLATES/linux_release.x86_64" ]; then
	echo "Modèles d'export Linux absents pour Godot $GODOT_VERSION ($TEMPLATES)" >&2
	exit 1
fi

# Version du jeu et du snap reprise de l'appdata
./maj_version.sh
VERSION="$(grep -m1 "^version:" "$SNAPCRAFT_FILE" | sed "s/^version:\s*//" | tr -d "'\"")"

# Godot ne doit pas importer (ni embarquer dans le .pck) les contenus de
# publication déjà rangés sous export/ : captures, icônes et builds.
mkdir -p export
touch export/.gdignore

rm -f "$SNAP_DIR/LittleAdventure.x86_64" "$SNAP_DIR/LittleAdventure.pck"

# Import des ressources puis export avec la version de Godot du projet
"$GODOT" --headless --path . --import
"$GODOT" --headless --path . --export-release "$PRESET" "$SNAP_DIR/LittleAdventure.x86_64"

for f in "$SNAP_DIR/LittleAdventure.x86_64" "$SNAP_DIR/LittleAdventure.pck"; do
	if [ ! -f "$f" ]; then
		echo "Échec de l'export ($f)" >&2
		exit 1
	fi
done
chmod 755 "$SNAP_DIR/LittleAdventure.x86_64"

# Avec un umask restrictif, le dossier snap/ du paquet (command-chain de
# l'extension gnome) sort en 700 et l'application ne se lance plus.
# Ne pas réempaqueter le .snap à la main : le Snap Store le refuserait.
umask 022

SNAP_NAME="$(grep -m1 "^name:" "$SNAPCRAFT_FILE" | sed "s/^name:\s*//")"
SNAP_FILE="${SNAP_NAME}_${VERSION}_amd64.snap"

(cd "$SNAP_DIR" && rm -f "$SNAP_FILE" && snapcraft pack --output "$SNAP_FILE")

# Tout doit être lisible par les autres, et les dossiers/exécutables traversables
BAD_PERMS="$(unsquashfs -ll "$SNAP_DIR/$SNAP_FILE" 2>/dev/null | awk '
	{ perm=$1 }
	perm ~ /^d/ && substr(perm,10,1) != "x" { print; next }
	perm ~ /^-/ && (substr(perm,8,1) != "r" || (substr(perm,4,1) == "x" && substr(perm,10,1) != "x")) { print }
')"
if [ -n "$BAD_PERMS" ]; then
	echo "Permissions inattendues dans le snap (relancer avec un umask 022) :" >&2
	echo "$BAD_PERMS" >&2
	exit 1
fi

echo "Version : $VERSION"
echo "Snap    : $SNAP_DIR/$SNAP_FILE ($(du -h "$SNAP_DIR/$SNAP_FILE" | cut -f1))"

if [ "${1:-}" = "--install" ]; then
	sudo snap remove "$SNAP_NAME" 2>/dev/null || true
	sudo snap install --dangerous "$SNAP_DIR/$SNAP_FILE"
else
	echo "Installer : sudo snap install --dangerous $SNAP_DIR/$SNAP_FILE"
	echo "Publier   : snapcraft upload $SNAP_DIR/$SNAP_FILE --release=stable"
fi
