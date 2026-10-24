#!/bin/bash
# Reporte le numéro de version de la dernière release déclarée dans l'appdata
# Flathub (première balise <release>) dans le reste du projet :
#   - common/singletons/globalVersion.gd      var version="X.Y.Z"
#   - export/linux/snap/snap/snapcraft.yaml   version: 'X.Y.Z'
#
# Usage : ajouter une <release version="X.Y.Z"> en tête de <releases> dans
# l'appdata, puis lancer ./maj_version.sh (appelé aussi par les scripts de build)
set -e

cd "$(dirname "$0")"

APPDATA="export/linux/flatpak/org.dupot.littleadventure.appdata.xml"
GLOBAL_VERSION="common/singletons/globalVersion.gd"
SNAPCRAFT="export/linux/snap/snap/snapcraft.yaml"

VERSION="$(grep -m1 -oP '<release\b[^>]*\bversion="\K[^"]+' "$APPDATA" || true)"
if [ -z "$VERSION" ]; then
	echo "Aucune <release version=\"...\"> trouvée dans $APPDATA" >&2
	exit 1
fi
echo "Version de l'appdata : $VERSION"

sed -i -E "s|^(var version ?= ?)\"[^\"]*\"|\1\"$VERSION\"|" "$GLOBAL_VERSION"
echo "  $GLOBAL_VERSION"

sed -i -E "s|^version:.*|version: '$VERSION'|" "$SNAPCRAFT"
echo "  $SNAPCRAFT"

# Contrôle : chaque fichier doit maintenant contenir la version
if ! grep -q "\"$VERSION\"" "$GLOBAL_VERSION"; then
	echo "Version non mise à jour dans $GLOBAL_VERSION" >&2
	exit 1
fi
if ! grep -q "^version: '$VERSION'" "$SNAPCRAFT"; then
	echo "Version non mise à jour dans $SNAPCRAFT" >&2
	exit 1
fi
echo "OK"
