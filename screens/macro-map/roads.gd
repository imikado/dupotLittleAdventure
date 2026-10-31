extends Node2D

# Trace les chemins de terre et les socles des etapes de la carte du monde

const WorldMap=preload("res://screens/macro-map.gd")

const BORDER=Color8(116, 84, 48)
const DIRT=Color8(196, 160, 104)
const DIRT_LIGHT=Color8(214, 182, 126)
const STONE_BORDER=Color8(92, 84, 76)
const STONE=Color8(196, 188, 170)
const STONE_LIGHT=Color8(226, 220, 204)

func _draw():
	# bordure puis terre, pour que les croisements restent propres
	for path in WorldMap.PATHS:
		_drawPath(path, 7, BORDER)
	for path in WorldMap.PATHS:
		_drawPath(path, 5, DIRT)
	for path in WorldMap.PATHS:
		_drawPath(path, 1, DIRT_LIGHT, Vector2(-1, -1))
	for place in [WorldMap.TREE, WorldMap.BEAR, WorldMap.CRABS]:
		_drawPad(place, 6)
	for place in [WorldMap.SPIDER_SOUTH, WorldMap.SPIDER_NORTH]:
		_drawPad(place, 4)

func _drawPath(path_, width_, color_, shift_=Vector2.ZERO):
	for i in path_.size()-1:
		draw_line(path_[i]+shift_, path_[i+1]+shift_, color_, width_)
		draw_circle(path_[i+1]+shift_, width_/2.0, color_)
	draw_circle(path_[0]+shift_, width_/2.0, color_)

func _drawPad(position_, radius_):
	draw_circle(position_, radius_+1, STONE_BORDER)
	draw_circle(position_, radius_, STONE)
	draw_circle(position_+Vector2(-1, -1), radius_-2, STONE_LIGHT)
