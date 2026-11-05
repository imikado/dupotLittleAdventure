@tool
extends Sprite2D

# Touffe de fleurs (decor sans collision) : trois variantes de couleurs

const TEXTURES=[preload("res://common/decor/flowers1.png"), preload("res://common/decor/flowers2.png"), preload("res://common/decor/flowers3.png")]

@export_range(0, 2) var variant:=0:
	set(value_):
		variant=value_
		texture=TEXTURES[variant]

func _ready():
	texture=TEXTURES[variant]
