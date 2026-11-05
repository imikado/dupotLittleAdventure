#!/bin/bash
# Génère le GIF de présentation (README, Flathub, réseaux) : voir tools/promoGif.gd.
# Godot enregistre la démo image par image (Movie Maker), puis ffmpeg assemble
# le GIF avec une palette calculée sur la vidéo, sans lissage des pixels.
# Ouvre brièvement une fenêtre du jeu.
#
# Usage : ./generate_gif.sh [FR|EN] [fichier.gif]   (EN et export/promo.gif par défaut)
# Variables : FPS (20 par défaut), WIDTH (640 par défaut, multiple de 320 conseillé)
set -e

cd "$(dirname "$0")"

GODOT="${GODOT:-$(command -v godot || echo "$HOME/apps/Godot_v4.7.2-stable_linux.x86_64")}"
LANG_GAME="${1:-EN}"
OUTPUT="${2:-export/promo.gif}"
FPS="${FPS:-20}"
WIDTH="${WIDTH:-640}"
HEIGHT=$((WIDTH*9/16))

if [ ! -x "$GODOT" ]; then
	echo "Godot introuvable ($GODOT) : définir la variable GODOT" >&2
	exit 1
fi

if ! command -v ffmpeg >/dev/null; then
	echo "ffmpeg introuvable : il sert à assembler le GIF" >&2
	exit 1
fi

if [ "$LANG_GAME" != "FR" ] && [ "$LANG_GAME" != "EN" ]; then
	echo "Langue inconnue ($LANG_GAME) : FR ou EN" >&2
	exit 1
fi

# Godot ne doit pas importer les contenus de publication rangés sous export/
mkdir -p export "$(dirname "$OUTPUT")"
touch export/.gdignore

FRAMES_DIR="$(mktemp -d)"
trap 'rm -rf "$FRAMES_DIR"' EXIT

"$GODOT" --headless --path . --import
LANG_GAME="$LANG_GAME" \
	"$GODOT" --path . --resolution "${WIDTH}x${HEIGHT}" --fixed-fps "$FPS" \
	--write-movie "$FRAMES_DIR/frame.png" -s res://tools/promoGif.gd

# palette commune à toute l'animation, sans tramage (rendu pixel art net)
ffmpeg -loglevel error -y -framerate "$FPS" -i "$FRAMES_DIR/frame%08d.png" \
	-vf "scale=${WIDTH}:${HEIGHT}:flags=neighbor,split[a][b];[a]palettegen=stats_mode=diff:max_colors=256[p];[b][p]paletteuse=dither=none:diff_mode=rectangle" \
	-loop 0 "$OUTPUT"

echo "GIF : $OUTPUT ($(du -h "$OUTPUT" | cut -f1), $(ls "$FRAMES_DIR"/frame*.png | wc -l) images)"
