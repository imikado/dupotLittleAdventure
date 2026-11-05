@tool
extends StaticBody2D

# Barriere en bois : le segment de 16 px (poteau + deux traverses) est repete
# `segments` fois, puis un poteau ferme le bout. Comme pour les personnages,
# l'origine (tri en profondeur) est 16 px au-dessus du pied.

const SEGMENT=16

@export_range(1, 12) var segments:=3:
	set(value_):
		segments=value_
		build()

func _ready():
	build()

func build():
	if !is_node_ready():
		return
	var width=segments * SEGMENT
	$sprite.region_rect=Rect2(0, 0, width, 15)
	$post.position=Vector2(width, 0)
	$collision.shape.size=Vector2(width + 4, 4)
	$collision.position=Vector2((width + 4) / 2.0, 14)
