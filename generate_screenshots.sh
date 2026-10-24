#!/bin/bash
# Génère les captures d'écran de présentation dans export/linux/screenshots
# (utilisées par l'appdata Flathub et le README) : voir tools/screenshots.gd.
# Ouvre brièvement une fenêtre du jeu.
#
# Usage : ./generate_screenshots.sh [FR|EN]   (langue du jeu, EN par défaut)
set -e

cd "$(dirname "$0")"

GODOT="${GODOT:-$(command -v godot || echo "$HOME/apps/Godot_v4.7.2-stable_linux.x86_64")}"
SIZE="1280x720"
SHOTS_DIR="export/linux/screenshots"
LANG_GAME="${1:-EN}"

if [ ! -x "$GODOT" ]; then
	echo "Godot introuvable ($GODOT) : définir la variable GODOT" >&2
	exit 1
fi

if [ "$LANG_GAME" != "FR" ] && [ "$LANG_GAME" != "EN" ]; then
	echo "Langue inconnue ($LANG_GAME) : FR ou EN" >&2
	exit 1
fi

# Godot ne doit pas importer (ni embarquer dans le .pck) les contenus de
# publication déjà rangés sous export/ : captures, icônes et builds.
mkdir -p export
touch export/.gdignore

mkdir -p "$SHOTS_DIR"

"$GODOT" --headless --path . --import
SHOTS_DIR="$PWD/$SHOTS_DIR" LANG_GAME="$LANG_GAME" \
	"$GODOT" --path . --resolution "$SIZE" -s res://tools/screenshots.gd

echo "Captures : $SHOTS_DIR"
