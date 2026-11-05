extends Node2D

# Chemins de terre et socles des etapes de la carte du monde, peints pixel par
# pixel dans une image comme le reste de la carte : bords nets sans contour
# (comme la limite herbe/sable), cailloux, ombre d'un pixel sous le chemin

const WorldMap=preload("res://screens/macro-map.gd")
const BACKGROUND=preload("res://screens/macro-map/images/world/worldmap.png")

const DIRT=Color8(190, 158, 104)
const DIRT_LIGHT=Color8(214, 186, 130)
const DIRT_DARK=Color8(164, 132, 86)
const STONE_BORDER=Color8(92, 84, 76)
const STONE=Color8(196, 188, 170)
const STONE_LIGHT=Color8(226, 220, 204)
const STONE_DARK=Color8(160, 150, 134)
# demi-largeur du chemin, puis de son ombre (en pixels)
const ROAD_RADIUS=2.3
const SHADOW_RADIUS=3.4
# bord du chemin, plus caillouteux
const EDGE_WIDTH=0.8
# l'ombre assombrit ce qui est dessous (herbe, sable)
const SHADOW=0.8

var texture:ImageTexture

func _ready():
	var background=BACKGROUND.get_image()
	background.decompress()
	var size=background.get_size()
	var image=Image.create(size.x, size.y, false, Image.FORMAT_RGBA8)
	_paintRoads(image, background)
	for place in [WorldMap.TREE, WorldMap.BEAR, WorldMap.CRABS]:
		_paintPad(image, background, place, 6.0, 4.0)
	for place in [WorldMap.SPIDER_SOUTH, WorldMap.SPIDER_NORTH]:
		_paintPad(image, background, place, 4.0, 3.0)
	texture=ImageTexture.create_from_image(image)
	queue_redraw()

func _draw():
	if texture:
		draw_texture(texture, Vector2.ZERO)

# distance de chaque pixel au chemin le plus proche, puis terre ou ombre
func _paintRoads(image_, background_):
	var width=image_.get_width()
	var distances={}
	for path in WorldMap.PATHS:
		var points=WorldMap.smoothPath(path)
		for i in points.size()-1:
			var a=points[i]
			var b=points[i+1]
			var left=int(floor(min(a.x, b.x)-SHADOW_RADIUS))
			var right=int(ceil(max(a.x, b.x)+SHADOW_RADIUS))
			var top=int(floor(min(a.y, b.y)-SHADOW_RADIUS))
			var bottom=int(ceil(max(a.y, b.y)+SHADOW_RADIUS))
			for y in range(top, bottom+1):
				for x in range(left, right+1):
					if x < 0 or y < 0 or x >= width or y >= image_.get_height():
						continue
					var center=Vector2(x+0.5, y+0.5)
					var closest=Geometry2D.get_closest_point_to_segment(center, a, b)
					var distance=center.distance_to(closest)
					var key=y*width+x
					if !distances.has(key) or distance < distances[key].x:
						# y : le pixel est-il sous la ligne du chemin ?
						distances[key]=Vector2(distance, center.y-closest.y)
	for key in distances:
		var x=key%width
		var y=key/width
		var distance=distances[key]
		if distance.x <= ROAD_RADIUS:
			image_.set_pixel(x, y, _dirtColor(x, y, distance.x > ROAD_RADIUS-EDGE_WIDTH))
		elif distance.x <= SHADOW_RADIUS and distance.y > 0.3:
			image_.set_pixel(x, y, background_.get_pixel(x, y).darkened(1.0-SHADOW))

# terre avec quelques cailloux clairs et sombres, toujours aux memes endroits
func _dirtColor(x_, y_, edge_):
	var noise=(x_*7919+y_*104729+x_*y_*31) % 100
	if edge_:
		return DIRT_DARK if noise < 55 else DIRT
	if noise < 12:
		return DIRT_LIGHT
	if noise < 22:
		return DIRT_DARK
	return DIRT

# dalle de pierre vue de dessus, aplatie, avec son ombre portee
func _paintPad(image_, background_, center_, radiusX_, radiusY_):
	var inside=func(x_, y_):
		var dx=(x_+0.5-center_.x)/radiusX_
		var dy=(y_+0.5-center_.y)/radiusY_
		return dx*dx+dy*dy <= 1.0
	for y in range(int(center_.y-radiusY_)-1, int(center_.y+radiusY_)+3):
		for x in range(int(center_.x-radiusX_)-1, int(center_.x+radiusX_)+2):
			if inside.call(x, y):
				var edge=!inside.call(x-1, y) or !inside.call(x+1, y) or !inside.call(x, y-1) or !inside.call(x, y+1)
				var dy=(y+0.5-center_.y)/radiusY_
				var dx=(x+0.5-center_.x)/radiusX_
				var color=STONE
				if edge:
					color=STONE_BORDER
				elif dy < -0.25 and dx < 0.35:
					color=STONE_LIGHT
				elif dy > 0.3:
					color=STONE_DARK
				image_.set_pixel(x, y, color)
			elif inside.call(x, y-1) or inside.call(x-1, y-1):
				# ombre d'un pixel sous la dalle
				var under=image_.get_pixel(x, y)
				if under.a==0.0:
					under=background_.get_pixel(x, y)
				image_.set_pixel(x, y, under.darkened(1.0-SHADOW))
