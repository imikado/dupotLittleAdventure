# Portraits des dialogues (40x40) dans le style de Little Escape 2 : la tete
# de Gordon (tools/gordonSprites.py) agrandie x1,5 et retouchee, recolorée
# pour chaque loup du village des arbres.
#
#   python3 tools/portraitSprites.py            ecrit dans common/ui/portraits/
#   python3 tools/portraitSprites.py <dossier>  ecrit des apercus agrandis
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import gordonSprites as G  # noqa: E402
from gordonSprites import Layer  # noqa: E402

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..')
PORTRAIT_DIR = os.path.join(ROOT, 'common', 'ui', 'portraits')

# tete de face (36x29), x0=2, y0=1. Touffes de joue : colonnes 0 a 4,
# rangees 17 a 26, sans contour
HEAD = [
    ".....dggggg................ddgggg...",
    ".....dggggg................ddgggg...",
    ".....dgggggggg............dgggggg...",
    "...ddggggggggg............dgggggg...",
    "...ddggggggggg............dgggggg...",
    "...ddgiiiiigggg.........ddggggiii...",
    "...ddgiiiiiiggg.........ddggggiii...",
    "...ddgiiiiiiggg.........ddggggiii...",
    "...ddgiiiiiiggg.........ddggggiii...",
    "...ddgiiiiiiggg........dgggggiiig...",
    "...ddgiiiiiiggg........dgggggiiig...",
    "...ddgiiiiiigggggggggggggggggigg....",
    "...ddggggggkkkkkkkkkggggkkkkkkkk....",
    "...ddggggggkkkkkkkkkggggkkkkkkkk....",
    "...ddggggkkkkkkkkkkkgggkkkkkkkkk....",
    ".....dggkkkkkkkkkkkkgggkkkkkkkkk....",
    ".....dggkkkkkkkkkkkkgggkkkkkkkkk....",
    "gggggggggggwwwkkkwgggggwkkkwwg...kkk",
    "gg...gggggggwwIkkwgggggwIkkwwggggkkk",
    "gg...gggggggwwIkkwgggggddddddddddkkk",
    "...ggggggggggggggggggggggggggggggggg",
    "..gggggggggggggggggggggggggggggggggg",
    "..gggggggggggggggggggggggggggggggggg",
    "ggg...gggggggggggggggggggggggggggggg",
    ".....ggggggggggggggggggggggggggggggg",
    ".....ggggggggggggggggggggggggggggggg",
    "...ggg..gggggggggggggggggggggggggggg",
    "........dddddddddgggggggggggggggggg.",
    "........dddddddddgggggggggggggggggg.",
]

def _happyRows():
    # content : sourcils releves d'une rangee, yeux plus ouverts, gueule
    # ouverte sous le trait de la bouche ; le contour du museau ne bouge pas
    rows = [list(r) for r in HEAD]
    for j in range(11, 17):
        for x in range(8, 32):
            rows[j][x] = HEAD[j + 1][x] if j < 16 else 'g'
    for x in range(8, 32):
        # haut des yeux : blanc au-dessus de la pupille
        if HEAD[17][x] in 'wkI':
            rows[16][x] = 'w'
    for x in range(24, 32):
        rows[20][x] = 'k'
        rows[21][x] = 'P' if 25 <= x <= 30 else 'k'
        rows[22][x] = 'k' if 25 <= x <= 30 else rows[22][x]
    return [''.join(r) for r in rows]


HEAD_HAPPY = _happyRows()

# pelage (base, sombre, interieur des oreilles), iris, tenue
WOLVES = {
    'gordon': {'fur': ((132, 126, 135), (107, 103, 110), (190, 184, 194)), 'iris': (106, 190, 48), 'outfit': 'strap'},
    'mom': {'fur': ((140, 134, 144), (107, 103, 110), (198, 192, 202)), 'iris': (48, 96, 130), 'outfit': 'dress', 'lashes': True},
    'seller': {'fur': ((143, 86, 59), (112, 66, 46), (200, 150, 120)), 'iris': (60, 120, 60), 'outfit': 'overalls', 'tuft': True},
    'gemSeller': {'fur': ((172, 50, 50), (130, 40, 40), (226, 140, 130)), 'iris': (70, 140, 40), 'outfit': 'greenOveralls', 'lashes': True, 'tuft': True},
    'craftsman': {'fur': ((138, 111, 48), (110, 88, 38), (200, 180, 120)), 'iris': (60, 80, 140), 'outfit': 'overalls', 'greyBrows': True, 'tuft': True},
}


def _palette(wolf):
    fur, dark, inner = wolf['fur']
    pal = dict(G.PAL)
    pal.update({'g': fur, 'd': dark, 'i': inner, 'I': wolf['iris'], 'P': (224, 110, 120),
                'K': (190, 186, 192), 'b': (91, 110, 225), 'B': (63, 63, 160), 'v': (75, 105, 47),
                'V': (58, 82, 36), 'D': (106, 160, 70), 'Y': (240, 210, 90), 'E': (106, 220, 120)})
    return pal


def headLayers(wolf, happy):
    rows = list(HEAD_HAPPY if happy else HEAD)
    if wolf.get('greyBrows'):
        rows = [r[:5] + r[5:].replace('k', 'K') if 10 <= j <= 16 else r for j, r in enumerate(rows)]
    face = Layer().art([r[:5].replace('g', '.') + r[5:] if 17 <= j <= 26 else r for j, r in enumerate(rows)], 2, 1)
    face.soft = True
    tufts = Layer().art([r[:5] if 17 <= j <= 26 else '' for j, r in enumerate(rows)], 2, 1)
    extra = Layer()
    if wolf.get('tuft'):
        # meche sur le crane, entre les oreilles
        extra.art([".d..", "dd.d", "dddd"], 18, 9)
    if wolf.get('lashes'):
        # cils au coin exterieur de chaque oeil
        y = 17 if not happy else 16
        extra.put(29 + 2, y, 'k')
        extra.put(12, y, 'k')
    return [face, (tufts, None), (extra, False)]


def body(wolf):
    L = Layer()
    # epaules arrondies sous la tete
    L.art([
        "....gggggggggggggggggggggg....",
        "..gggggggggggggggggggggggggg..",
        ".gggggggggggggggggggggggggggg.",
        "gggggggggggggggggggggggggggggg",
        "gggggggggggggggggggggggggggggg",
        "gggggggggggggggggggggggggggggg",
        "gggggggggggggggggggggggggggggg",
        "gggggggggggggggggggggggggggggg",
        "gggggggggggggggggggggggggggggg",
        "gggggggggggggggggggggggggggggg",
    ], 5, 30)
    outfit = wolf['outfit']
    if outfit == 'strap':
        # bandouliere de l'epaule droite a la hanche gauche, boucle
        for k in range(10):
            for w in range(3):
                L.put(27 - k * 2 + w, 30 + k, 'o' if w < 2 else 'O')
        L.rect(17, 34, 3, 2, 'y')
    elif outfit == 'dress':
        L.art([
            "....vvvvvvvv.....vvvvvvvvv....",
            "..vvvvvvvvvvv...vvvvvvvvvvvv..",
            ".vvDvvvvvDvvvv.vvvvDvvvvvDvvv.",
            "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv",
            "vvvvDvvvvvvDvvvvvvDvvvvvvDvvvv",
            "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv",
            "vDvvvvvVDvvvvvvvDvvvvvvvDvvvvv",
            "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv",
            "vvvvDvvvvvvvvDvvvvvvvDvvvvvvDv",
            "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv",
        ], 5, 30)
    else:
        c, C = ('v', 'V') if outfit == 'greenOveralls' else ('b', 'B')
        # bretelles et bavette de salopette
        L.rect(10, 30, 3, 10, c)
        L.rect(27, 30, 3, 10, c)
        L.rect(12, 34, 16, 6, c)
        L.rect(12, 34, 16, 1, C)
        L.put(11, 32, 'Y')
        L.put(28, 32, 'Y')
        if outfit == 'greenOveralls':
            L.rect(19, 36, 2, 2, 'E')
    return L


def portrait(name, happy):
    wolf = WOLVES[name]
    G.PAL, saved = _palette(wolf), G.PAL
    try:
        im = G.compose([body(wolf)] + headLayers(wolf, happy), 40, 40)
    finally:
        G.PAL = saved
    return im


# --- ours et crabes : on garde leur tete, avec les yeux de Little Escape 2
# (gros bloc de sourcil noir sur un oeil blanc a pupille). La zone des yeux
# est entierement repeinte : relancer le script donne le meme resultat.

BEAR_EYES = {
    # (x, y) du coin haut gauche : rangees de sourcils puis d'yeux
    False: [
        "kkkkkkk.......kkkkkkk",
        "kkkkkkkk.....kkkkkkkk",
        "..kkkkkk.....kkkkkk..",
        ".wwkkw.........wkkww.",
        ".wwkkw.........wkkww.",
    ],
    True: [
        "..kkkkk.......kkkkk..",
        ".kkkkkkk.....kkkkkkk.",
        ".wwwwww.......wwwwww.",
        ".wwkkww.......wwkkww.",
        ".wwkkww.......wwkkww.",
    ],
}

CRAB_EYE = {
    # bulle de l'oeil (x13 a x26, y3 a y8) : sourcil noir et pupille
    False: [
        ".wwwwwwwwwwww.",
        "kkkkkkkkkkkkkk",
        "wkkkkkkkkkkkkw",
        "wwwwvvkkkvwwww",
        "wwwwvvkkkvvwww",
        ".wwwvvvvvvwww.",
    ],
    True: [
        ".wkkkkkkkkkkw.",
        "wkkkkkkkkkkkkw",
        "wwwwvvvvvvwwww",
        "wwwwvwkkkvwwww",
        "wwwvvvkkkvvwww",
        ".wwwvvvvvvwww.",
    ],
}

SPECIES_COLORS = {'k': (0, 0, 0, 255), 'w': (255, 255, 255, 255), 'v': (63, 22, 179, 255)}


def patchEyes(path, kind, happy):
    from PIL import Image
    im = Image.open(path).convert('RGBA')
    if kind == 'bear':
        fur = im.getpixel((20, 15))
        for y in range(12, 19):
            for x in range(10, 31):
                if im.getpixel((x, y))[:3] in ((0, 0, 0), (255, 255, 255), (99, 155, 255), (143, 86, 59)):
                    im.putpixel((x, y), fur)
        rows, x0, y0 = BEAR_EYES[happy], 10, 13 if not happy else 12
    else:
        rows, x0, y0 = CRAB_EYE[happy], 13, 3
    for j, row in enumerate(rows):
        for i, c in enumerate(row):
            if c != '.':
                im.putpixel((x0 + i, y0 + j), SPECIES_COLORS[c])
    return im


OTHERS = {'bear': 'bear', 'bearSeller': 'bear', 'crab': 'crab', 'crabPresenter': 'crab'}


def build():
    out = {}
    for name in WOLVES:
        out[name + '.png'] = portrait(name, False)
        out[name + '-happy.png'] = portrait(name, True)
    return out


if __name__ == '__main__':
    images = build()
    if len(sys.argv) > 1:
        from PIL import Image
        names = list(images)
        sheet = Image.new('RGBA', (44 * 4, 44 * ((len(names) + 3) // 4)), (200, 220, 200, 255))
        for k, name in enumerate(names):
            sheet.alpha_composite(images[name], ((k % 4) * 44 + 2, (k // 4) * 44 + 2))
        G.preview(os.path.join(sys.argv[1], 'preview-portraits.png'), sheet, 5)
    else:
        for name, im in images.items():
            im.save(os.path.join(PORTRAIT_DIR, name))
            print(name)
        for name, kind in OTHERS.items():
            for happy in (False, True):
                path = os.path.join(PORTRAIT_DIR, name + ('-happy' if happy else '') + '.png')
                patchEyes(path, kind, happy).save(path)
                print(os.path.basename(path))
