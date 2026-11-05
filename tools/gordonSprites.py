# Planches d'exploration de Gordon (style Little Escape 2 : grosse tete
# toujours tournee de profil, petit corps). Chaque partie du corps est un
# calque qui recoit son propre contour de 1 px.
#
#   python3 tools/gordonSprites.py            ecrit dans common/characters/player/
#   python3 tools/gordonSprites.py <dossier>  ecrit des apercus agrandis
import os
import sys
from PIL import Image

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..')
PLAYER_DIR = os.path.join(ROOT, 'common', 'characters', 'player')

PAL = {
    'k': (34, 32, 52),     # contour, sourcils, truffe
    'g': (132, 126, 135),  # pelage
    'l': (150, 144, 154),  # pelage clair
    'd': (107, 103, 110),  # pelage sombre
    'p': (64, 58, 70),     # bout de queue
    'w': (255, 255, 255),
    'i': (190, 184, 194),  # interieur des oreilles
    'T': (226, 232, 238),  # trainee de l'epee
    'G': (106, 190, 48),   # iris
    'b': (63, 63, 116),    # pantalon
    'B': (44, 44, 86),     # pantalon sombre
    'o': (232, 148, 58),   # bandouliere
    'O': (176, 94, 38),
    'y': (246, 214, 120),  # boucle
    'S': (217, 160, 102),  # bois clair
    's': (143, 86, 59),    # bois
    'r': (102, 57, 49),    # bois sombre
    'm': (105, 106, 106),  # fer de la pelle
    'M': (150, 152, 152),
    'c': (172, 50, 50),    # manche de la pelle
    'e': (120, 86, 50),    # terre
}
OUTLINE = PAL['k']


class Layer:
    def __init__(self, w=32, h=32):
        self.w, self.h = w, h
        self.px = {}

    def art(self, rows, x0=0, y0=0):
        for j, row in enumerate(rows):
            for i, ch in enumerate(row):
                if ch != '.' and ch != ' ':
                    self.px[(x0 + i, y0 + j)] = ch
        return self

    def put(self, x, y, ch):
        self.px[(x, y)] = ch

    def rect(self, x, y, w, h, ch):
        for j in range(h):
            for i in range(w):
                self.px[(x + i, y + j)] = ch

    def line(self, x0, y0, x1, y1, ch, width=1):
        n = max(abs(x1 - x0), abs(y1 - y0), 1)
        for t in range(n + 1):
            x = round(x0 + (x1 - x0) * t / n)
            y = round(y0 + (y1 - y0) * t / n)
            for dx in range(width):
                self.px[(x + dx, y)] = ch

    def shift(self, dx, dy):
        self.px = {(x + dx, y + dy): c for (x, y), c in self.px.items()}
        return self

    def flip(self, cx):
        # miroir autour de la colonne cx (pixels x et 2cx-x)
        self.px = {(2 * cx - x, y): c for (x, y), c in self.px.items()}
        return self


def compose(layers, w=32, h=32):
    # chaque calque recoit son propre contour de 1 px, dessine par-dessus
    # les calques precedents (sauf ceux marques sans separation)
    grid = {}
    softs = []
    flat = []
    for item in layers:
        flat += item if isinstance(item, list) else [item]
    for item in flat:
        layer, sep = (item if isinstance(item, tuple) else (item, True))
        filled = layer.px
        # sep None : calque sans contour automatique (contour peint a la main)
        for (x, y) in (list(filled) if sep is not None else []):
            for nx, ny in ((x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)):
                if (nx, ny) in filled:
                    continue
                if sep or (nx, ny) not in grid:
                    grid[(nx, ny)] = 'k'
        for p, c in filled.items():
            grid[p] = c
        if getattr(layer, 'soft', False):
            softs.append(set(filled))
    # sous la tete, pas de trait noir sur le cou et le torse : une ombre de
    # menton (sinon la tete a l'air posee sur le corps)
    for heads in softs:
        for (x, y) in heads:
            below = grid.get((x, y + 2))
            if (x, y + 1) not in heads and grid.get((x, y + 1)) == 'k' and below not in (None, 'k'):
                grid[(x, y + 1)] = 'd'
    im = Image.new('RGBA', (w, h), (0, 0, 0, 0))
    for (x, y), c in grid.items():
        if 0 <= x < w and 0 <= y < h:
            im.putpixel((x, y), PAL[c] + (255,))
    return im

# tete reprise au pixel pres du heros de Little Escape 2 (oreilles de 3/4,
# gros sourcils, yeux blancs dessous, large museau plat, touffes de joue a
# gauche), aux couleurs de Gordon. Toujours tournee vers la droite ;
# x0=4, y0=0 au repos. Contour autour de la silhouette, sauf les touffes de
# joue (colonnes 0 a 2) qui restent fines comme dans Little Escape 2.
HEAD = [
    "...dggg...........dggg..",
    "...dggggg........dgggg..",
    "..dgggggg........dgggg..",
    "..dgiiiggg......dgggii..",
    "..dgiiiigg......dgggii..",
    "..dgiiiigg......dgggii..",
    "..dgiiiigg.....dgggiig..",
    "..dgiiiigggggggggggig...",
    "..dggggkkkkkkgggkkkkk...",
    "..dgggkkkkkkkggkkkkkk...",
    "...dgkkkkkkkkggkkkkkk...",
    "gggggggwwkkwgggwkkwg..kk",
    "g..gggggwkkwgggdddddddkk",
    "..gggggggggggggggggggggg",
    ".ggggggggggggggggggggggg",
    "gg..gggggggggggggggggggg",
    "...ggggggggggggggggggggg",
    "..gg.ggggggggggggggggggg",
    ".....ddddddgggggggggggg.",
]

# clignement : sourcils baisses d'une rangee (2e image de Little Escape 2)
HEAD_BLINK = HEAD[:7] + [
    "..dgiiikkkkkkgggkkkkk...",
    "..dgggkkkkkkkggkkkkkk...",
    "..dggkkkkkkkkggkkkkkk...",
    "...dgggwwkkwgggwkkwgk...",
] + HEAD[11:]


def _backRows():
    # de dos : ni yeux, ni sourcils, ni bouche ; dos des oreilles et
    # arriere du crane plus sombres, la truffe depasse toujours
    rows = []
    for j, row in enumerate(HEAD):
        r = list(row)
        for x, c in enumerate(r):
            if c == 'i':
                r[x] = 'd'
            elif c == 'w' or (c == 'k' and x < 22) or (j == 12 and c == 'd'):
                r[x] = 'g'
        if 7 <= j <= 17:
            filled = [x for x, c in enumerate(r) if c != '.' and x > 2]
            for x in filled[:2]:
                r[x] = 'd'
        rows.append(''.join(r))
    return rows


HEAD_BACK = _backRows()


def head(dy=0, blink=False, back=False, dx=0):
    rows = HEAD_BACK if back else (HEAD_BLINK if blink else HEAD)
    face = Layer().art([r[:3].replace('g', '.').replace('d', '.') + r[3:] if 11 <= j <= 17 else r for j, r in enumerate(rows)], 4 + dx, dy)
    face.soft = True
    tufts = Layer().art([r[:3] if 11 <= j <= 17 else '' for j, r in enumerate(rows)], 4 + dx, dy)
    return [face, (tufts, None)]


def neck(dy=0, x=14):
    # cou fin entre la tete et le torse
    L = Layer()
    L.rect(x, 18 + dy, 4, 2, 'd')
    return (L, False)


# --- de face (marche vers le bas, attente)

def torsoFront(dy=0, back=False):
    L = Layer()
    L.rect(12, 20 + dy, 8, 5 - dy, 'g')
    if back:
        L.rect(12, 20 + dy, 8, 1, 'd')
    # bandouliere : epaule droite a l'ecran vers la hanche gauche
    # (la planche de dos est retournee a l'affichage, donc inversee a l'ecran)
    L.line(19, 20 + dy, 12, 24, 'o')
    if not back:
        L.put(16, 22, 'y')
    return L


def legFront(x, lift=0, dark=False):
    L = Layer()
    L.rect(x, 25, 4, 2, 'b')
    L.rect(x, 27, 4, 3 - lift, 'B' if dark else 'b')
    L.rect(x, 30 - lift, 4, 1, 'g')
    return L


def armFront(x, dy=0, swing=0):
    # bras de 2 px : en avant il descend plus bas avec une main plus claire,
    # en arriere il est raccourci et sa main passe dans l'ombre
    L = Layer()
    if swing > 0:
        L.rect(x, 21 + dy, 2, 3, 'g')
        L.rect(x, 24 + dy, 2, 2, 'l')
    elif swing < 0:
        L.rect(x, 21 + dy, 2, 1, 'g')
        L.rect(x, 22 + dy, 2, 1, 'd')
    else:
        L.rect(x, 21 + dy, 2, 4, 'g')
    return L


def tailFront(sway=0):
    L = Layer()
    L.art([
        ".gg.",
        "gggg",
        "gggp",
        "ggpp",
        ".pp.",
    ], 20 + sway, 22)
    return L


def tailBack(sway=0):
    # de dos, la queue pend devant le pantalon
    L = Layer()
    L.art([
        ".gg.",
        "gggg",
        "gggg",
        "gggp",
        ".ppp",
        "..p.",
    ], 14 + sway, 23)
    return L


def frontFrame(dy=0, blink=False, sway=0, lift=(0, 0), swing=(0, 0)):
    return compose([tailFront(sway), legFront(12, lift[0], lift[0] > 0), legFront(16, lift[1], lift[1] > 0),
                    torsoFront(dy), neck(dy), armFront(10, dy, swing[0]), armFront(20, dy, swing[1]),
                    head(dy, blink)])


def backFrame(dy=0, sway=0, lift=(0, 0), swing=(0, 0)):
    return compose([legFront(12, lift[0], lift[0] > 0), legFront(16, lift[1], lift[1] > 0),
                    torsoFront(dy, True), neck(dy), armFront(10, dy, swing[0]), armFront(20, dy, swing[1]),
                    tailBack(sway), head(dy, back=True)])


# --- de profil (vers la droite)

def legSide(hip, swing, lift=0, dark=False):
    L = Layer()
    c = 'B' if dark else 'b'
    for r in range(25, 30):
        t = (r - 25) / 4
        x = hip + round(swing * t)
        L.rect(x, r - (lift if r > 26 else 0), 3, 1, c)
    fx = hip + swing
    L.rect(fx, 30 - lift, 4, 1, 'g')
    return L


def armSide(swing, dy=0, back=False):
    # bras de 2 px en ombre, contour seulement a l'arriere et sous la main,
    # main en gris de base ; l'epaule reste en place, la main avance ou recule
    L = Layer()
    if back:
        # bras du fond : on ne voit que la main qui depasse du torse
        L.rect(14 + swing, 22 + dy, 2, 3, 'd')
        return L
    half = (swing + (1 if swing > 0 else 0)) // 2
    rows = {21: 15, 22: 15 + half, 23: 15 + swing, 24: 15 + swing}
    for y, x in rows.items():
        c = 'd' if y < 23 else 'g'
        L.put(x, y + dy, c)
        L.put(x + 1, y + dy, c)
        L.put(x - 1, y + dy, 'k')
    L.put(15 + swing, 25 + dy, 'k')
    L.put(16 + swing, 25 + dy, 'k')
    L.put(17 + swing, 23 + dy, 'k')
    L.put(17 + swing, 24 + dy, 'k')
    return (L, None)


def torsoSide(dy=0):
    L = Layer()
    L.rect(12, 20 + dy, 7, 6 - dy, 'g')
    L.line(18, 20 + dy, 12, 25, 'o')
    L.put(15, 22 + (dy + 1) // 2, 'y')
    return L


def tailSide(sway=0):
    L = Layer()
    L.art([
        ".pgg..",
        "ppgggg",
        ".pgggg",
        "..gggg",
    ], 7, 21 + sway)
    return L


def sideFrame(dy=0, sway=0, legs=(0, 0), lifts=(0, 0), arm=0):
    return compose([armSide(-arm, dy, True), legSide(12, legs[1], lifts[1], True), tailSide(sway),
                    torsoSide(dy), neck(dy), legSide(15, legs[0], lifts[0]), head(dy), armSide(arm, dy)])


def sheet(frames, fw=32):
    out = Image.new('RGBA', (fw * len(frames), 32), (0, 0, 0, 0))
    for i, f in enumerate(frames):
        out.alpha_composite(f, (i * fw, 0))
    return out


def preview(name, im, scale=8):
    bg = Image.new('RGBA', im.size, (200, 220, 200, 255))
    bg.alpha_composite(im)
    bg.resize((im.width * scale, im.height * scale), Image.NEAREST).save(name)


# --- objets en main

def sword(hand, tip):
    # epee en bois sans contour noir : lame de 2 px (bois clair, liseré
    # plus sombre dessous ou a droite). Rend (lame, garde) : la garde de 3 px
    # en bois sombre est posee par-dessus la main, au premier pixel de la
    # lame hors du poing, perpendiculaire a la lame
    L = Layer()
    hx, hy = hand
    tx, ty = tip
    n = max(abs(tx - hx), abs(ty - hy))
    horizontal = abs(tx - hx) >= abs(ty - hy)
    ox, oy = (0, 1) if horizontal else (1, 0)
    pts = [(round(hx + (tx - hx) * t / n), round(hy + (ty - hy) * t / n)) for t in range(n + 1)]
    fist = {(hx + i, hy + j) for i in range(2) for j in range(2)}
    g = next(k for k, p in enumerate(pts) if p not in fist)
    for x, y in pts[g + 1:-1]:
        L.put(x + ox, y + oy, 's')
    for x, y in pts[g + 1:]:
        L.put(x, y, 'S')
    guard = Layer()
    gx, gy = pts[g]
    px, py = (0, 1) if horizontal else (1, 0)
    for k in (-1, 0, 1):
        guard.put(gx + px * k, gy + py * k, 'r')
    return (L, None), (guard, None)


def hand(x, y, c='g'):
    L = Layer()
    L.rect(x, y, 2, 2, c)
    return L


def armTo(x, y, dy=0, c='d', sx=14):
    # bras de 2 px de l'epaule jusqu'a la main ; contour seulement hors du corps
    L = Layer()
    L.line(sx, 21 + dy, x, y, c, 2)
    L.rect(sx, 21 + dy, 2, 1, c)
    return (L, False)


def shifted(layers, dx):
    out = []
    flat = []
    for item in layers:
        flat += item if isinstance(item, list) else [item]
    for item in flat:
        layer, sep = (item if isinstance(item, tuple) else (item, True))
        out.append((layer.shift(dx, 0), sep))
    return out


# images de l'attaque, dans l'ordre des indices de player.tscn :
# 0 garde basse, 1 elan (lame dans le dos), 2 lame haute derriere, 3 lame
# haute devant le museau, 4 suivi vers le bas, 5 coup (lame a l'horizontale,
# corps penche en avant). Jambes ecartees comme dans Type To Fight.
ATTACK = [
    # (main, pointe, epee devant, decalage du corps, avance de la tete, baisse, jambes)
    ((20, 22), (31, 15), True, 0, 0, 0, (3, -3)),
    ((11, 22), (-1, 19), False, -1, -1, 1, (3, -3)),
    ((10, 20), (-2, 6), False, -1, -1, 0, (3, -3)),
    ((21, 20), (32, 7), True, 0, 0, 0, (3, -3)),
    ((22, 23), (33, 30), True, 1, 1, 1, (4, -3)),
    ((22, 21), (38, 21), True, 1, 2, 1, (4, -3)),
]

# trainee legere au-dessus du coup (image 5)
TRAIL = [(30, 12), (31, 12), (32, 13), (33, 14), (34, 15), (35, 16), (35, 17), (36, 18), (36, 19)]


def attackFrame(i):
    (hx, hy), tip, front, dx, hdx, dy, legs = ATTACK[i]
    blade, guard = sword((hx, hy), tip)
    layers = [legSide(12, legs[1], 0, True), tailSide(0)]
    if not front:
        layers += [blade]
    layers += [torsoSide(dy), neck(dy), legSide(15, legs[0], 0)]
    layers += [head(dy, dx=hdx - dx)]
    if front:
        layers += [blade]
    layers += [armTo(hx, hy, dy), hand(hx, hy), guard]
    # le personnage reste au centre du cadre de 64 px ; il recule a l'elan
    # et avance au coup
    im = compose(shifted(layers, 16 + dx), 64, 32)
    if i == 5:
        for x, y in TRAIL:
            if im.getpixel((x + 16 + dx, y))[3] == 0:
                im.putpixel((x + 16 + dx, y), PAL['T'] + (255,))
    return im


# --- creuser (vers la droite), pelle a manche en bois

def spadeHandle(top, bottom):
    # manche en bois de 2 px sans contour, poignee en T
    L = Layer()
    L.line(top[0] + 1, top[1] + 1, bottom[0] + 1, bottom[1] - 2, 'r')
    L.line(top[0], top[1], bottom[0], bottom[1] - 3, 's')
    L.rect(top[0] - 1, top[1], 3, 1, 'r')
    return (L, None)


def spadeBlade(bottom, dirt=False):
    L = Layer()
    bx, by = bottom
    L.rect(bx - 1, by - 2, 3, 3, 'm')
    L.put(bx - 1, by - 2, 'M')
    L.put(bx, by - 2, 'M')
    if dirt:
        L.rect(bx - 1, by - 3, 3, 1, 'e')
    return L


DIG = [
    # (haut du manche, fer, main haute, main basse, terre, baisse, jambes)
    ((20, 19), (25, 30), (19, 20), (21, 24), False, 0, (2, -2)),
    ((20, 18), (25, 28), (19, 19), (21, 23), False, 0, (2, -2)),
    ((21, 20), (26, 31), (20, 21), (22, 25), False, 1, (2, -2)),
    ((21, 20), (26, 31), (20, 21), (22, 25), False, 1, (3, -2)),
    ((19, 20), (25, 28), (18, 21), (21, 24), True, 0, (2, -2)),
    ((18, 19), (26, 25), (17, 20), (20, 22), True, 0, (1, -2)),
]


def digFrame(i):
    top, bottom, (ux, uy), (lx, ly), dirt, dy, legs = DIG[i]
    layers = [legSide(12, legs[1], 0, True), tailSide(0),
              torsoSide(dy), neck(dy), legSide(15, legs[0], 0), head(dy),
              armTo(ux, uy, dy, 'd', 14), hand(ux, uy),
              spadeHandle(top, bottom), spadeBlade(bottom, dirt),
              armTo(lx, ly, dy, 'd', 15), hand(lx, ly)]
    im = compose(layers)
    if i == 5:
        # mottes de terre projetees
        for x, y in ((28, 21), (30, 19), (29, 23), (31, 22)):
            im.putpixel((x, y), PAL['e'] + (255,))
    return im


# --- escalade (de dos)

CLIMB = [
    # (main gauche, main droite, levee des pieds) : une main haute contre le
    # bord de la tete, l'autre plus bas ; gauche haute sur les images 0-1,
    # droite haute sur les images 2-3
    ((2, 10), (26, 15), (0, 2)),
    ((2, 11), (26, 16), (0, 1)),
    ((2, 15), (26, 10), (2, 0)),
    ((2, 16), (26, 11), (1, 0)),
]


def climbArm(shoulder, hand_):
    # bras de 2 px en ombre, de l'epaule a la main : il monte en diagonale
    # puis le long de la tete
    L = Layer()
    sx, sy = shoulder
    hx, hy = hand_
    # diagonale de l'epaule au bord de la tete, puis avant-bras vertical
    ey = max(hy + 2, 17)
    for y in range(ey, sy + 1):
        t = (y - ey) / max(sy - ey, 1)
        L.rect(round(hx + (sx - hx) * t), y, 2, 1, 'd')
    L.rect(hx, hy + 2, 2, ey - hy - 1, 'd')
    return L


def climbFrame(i):
    a, b, lift = CLIMB[i]
    return compose([legFront(12, lift[0], lift[0] > 0), legFront(16, lift[1], lift[1] > 0),
                    climbArm((10, 20), a), climbArm((20, 20), b), torsoFront(0, True), neck(0),
                    tailBack(0), head(0, back=True), hand(*a, 'l'), hand(*b, 'l')])


def savePalette(im, path):
    # planche en mode P, index 0 transparent
    colors = sorted({px[:3] for px in im.getdata() if px[3] > 0})
    out = Image.new('P', im.size, 0)
    flat = [0, 0, 0]
    for c in colors:
        flat += list(c)
    out.putpalette(flat + [0] * (768 - len(flat)))
    index = {c: i + 1 for i, c in enumerate(colors)}
    out.putdata([index[px[:3]] if px[3] > 0 else 0 for px in im.getdata()])
    out.save(path, transparency=0)


def build():
    sheets = {}
    # attente : repos, respiration, repos (queue qui bouge), clignement
    sheets['Player-idle.png'] = sheet([frontFrame(), frontFrame(1), frontFrame(0, sway=1), frontFrame(0, True)])
    # marche : un pied toujours au sol, la tete ne monte que de 1 px
    UP = [0, 0, -1, -1, 0, 0, -1, -1]
    SWAY = [0, 0, 1, 1, 0, 0, 1, 1]
    LIFT_A = [1, 2, 2, 1, 0, 0, 0, 0]
    LIFT_B = [0, 0, 0, 0, 1, 2, 2, 1]
    # bras oppose a la jambe levee
    ARM = [-1, -1, -1, 0, 1, 1, 1, 0]
    sheets['Player-walking-down.png'] = sheet([frontFrame(UP[i], sway=SWAY[i], lift=(LIFT_A[i], LIFT_B[i]), swing=(ARM[i], -ARM[i])) for i in range(8)])
    sheets['Player-walking-up.png'] = sheet([backFrame(UP[i], sway=SWAY[i], lift=(LIFT_A[i], LIFT_B[i]), swing=(ARM[i], -ARM[i])) for i in range(8)])
    LEG = [3, 2, 0, -2, -3, -2, 0, 2]
    LIFTF = [0, 0, 0, 0, 0, 1, 1, 0]
    LIFTR = [0, 1, 1, 0, 0, 0, 0, 0]
    ARMS = [-2, -1, 0, 1, 2, 1, 0, -1]
    sheets['Player-walking-right.png'] = sheet([sideFrame(UP[i], SWAY[i], (LEG[i], -LEG[i]), (LIFTF[i], LIFTR[i]), ARMS[i]) for i in range(8)])
    sheets['player-attack1.png'] = sheet([attackFrame(i) for i in range(6)], 64)
    sheets['Player-digging-right.png'] = sheet([digFrame(i) for i in range(6)])
    sheets['Player-climbing.png'] = sheet([climbFrame(i) for i in range(4)])
    return sheets


if __name__ == '__main__':
    sheets = build()
    if len(sys.argv) > 1:
        for name, im in sheets.items():
            preview(os.path.join(sys.argv[1], 'preview-' + name), im, 6)
    else:
        for name, im in sheets.items():
            path = os.path.join(PLAYER_DIR, name)
            if name == 'player-attack1.png':
                savePalette(im, path)
            else:
                im.save(path)
            print(path, im.size)
