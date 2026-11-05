#!/bin/bash
# Met à jour les adresses des captures d'écran de l'appdata Flathub
# (bloc <screenshots>) : une <screenshot> par fichier de
# export/linux/screenshots/Screenshot_*.png, la première en type="default",
# en pointant sur raw.githubusercontent.com au commit donné.
#
# Usage : ./update_screenshots_appdata.sh [COMMIT]   (HEAD par défaut)
# Les captures doivent être commitées dans ce commit et poussées sur GitHub,
# sinon les adresses ne répondent pas.
set -e

cd "$(dirname "$0")"

APPDATA="export/linux/flatpak/org.dupot.littleadventure.appdata.xml"
SHOTS_DIR="export/linux/screenshots"
REPO_URL="https://raw.githubusercontent.com/imikado/dupotLittleAdventure"

COMMIT="$(git rev-parse --verify "${1:-HEAD}^{commit}")"
echo "Commit : $COMMIT"

SHOTS=()
for path in $(git ls-tree --name-only "$COMMIT" "$SHOTS_DIR/" | grep -E '/Screenshot_[0-9]+\.png$' | sort); do
	SHOTS+=("$path")
done
if [ ${#SHOTS[@]} -eq 0 ]; then
	echo "Aucune capture $SHOTS_DIR/Screenshot_*.png dans le commit $COMMIT" >&2
	exit 1
fi

# avertissements : captures locales différentes du commit, commit non poussé
if ! git diff --quiet "$COMMIT" -- "$SHOTS_DIR"; then
	echo "Attention : $SHOTS_DIR diffère du commit $COMMIT (captures non commitées ?)" >&2
fi
if [ -z "$(git branch -r --contains "$COMMIT" 2>/dev/null)" ]; then
	echo "Attention : le commit $COMMIT n'est sur aucune branche distante (à pousser)" >&2
fi

URLS=()
for path in "${SHOTS[@]}"; do
	URLS+=("$REPO_URL/$COMMIT/$path")
done

python3 - "$APPDATA" "${URLS[@]}" <<'EOF'
import re
import sys

appdata, urls = sys.argv[1], sys.argv[2:]
text = open(appdata, encoding='utf-8').read()
match = re.search(r'^([ \t]*)<screenshots>.*?</screenshots>[ \t]*$', text, re.S | re.M)
if not match:
    sys.exit("Bloc <screenshots> introuvable dans " + appdata)
indent = match.group(1)
lines = [indent + '<screenshots>']
for i, url in enumerate(urls):
    lines.append(indent + '  <screenshot type="default">' if i == 0 else indent + '  <screenshot>')
    lines.append(indent + '    <image>' + url + '</image>')
    lines.append(indent + '  </screenshot>')
lines.append(indent + '</screenshots>')
text = text[:match.start()] + '\n'.join(lines) + text[match.end():]
open(appdata, 'w', encoding='utf-8').write(text)
EOF

for url in "${URLS[@]}"; do
	echo "  $url"
done
echo "OK : ${#URLS[@]} captures dans $APPDATA"
