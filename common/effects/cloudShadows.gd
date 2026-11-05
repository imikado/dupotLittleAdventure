extends ColorRect

# Ombres de nuages : le rectangle couvre toute la zone de jeu (le ReferenceRect
# qui borne la camera), avec une marge pour les bords

@export var area:NodePath

func _ready():
	mouse_filter=Control.MOUSE_FILTER_IGNORE
	var rect:ReferenceRect=get_node_or_null(area)
	if rect==null:
		return
	global_position=rect.global_position - Vector2(64, 64)
	size=rect.size + Vector2(128, 128)
