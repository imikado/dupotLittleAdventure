extends Node2D

# Feuilles qui tombent des arbres : chaque feuille part d'un point au hasard
# de la zone, descend en se balancant (4 images pour simuler la rotation),
# s'estompe en touchant le sol puis repart d'ailleurs

const FRAME_TIME=0.18
const FALL_SPEED=9.0

@export var area:NodePath
@export var count:=10

var leaves=[]
var rect:Rect2

func _ready():
	var ref:ReferenceRect=get_node_or_null(area)
	if ref==null:
		return
	rect=Rect2(ref.global_position, ref.size)
	var texture=preload("res://common/effects/leaf.png")
	for i in count:
		var sprite=Sprite2D.new()
		var atlas=AtlasTexture.new()
		atlas.atlas=texture
		sprite.texture=atlas
		add_child(sprite)
		var leaf={"sprite":sprite, "atlas":atlas}
		leaves.append(leaf)
		respawn(leaf)
		# au demarrage, les feuilles sont deja en cours de chute
		leaf.clock=randf() * leaf.duration

func respawn(leaf_):
	leaf_.start=rect.position + Vector2(randf() * rect.size.x, randf() * rect.size.y)
	leaf_.duration=randf_range(4.0, 7.0)
	leaf_.clock=0.0
	leaf_.phase=randf() * TAU
	# surtout des feuilles vertes, quelques jaunes et rousses
	leaf_.color=0 if randf() < 0.6 else (1 if randf() < 0.5 else 2)

func _process(delta):
	for leaf in leaves:
		leaf.clock+=delta
		if leaf.clock >= leaf.duration:
			respawn(leaf)
		var t=leaf.clock
		var sway=sin(t * 1.8 + leaf.phase) * 6.0
		leaf.sprite.global_position=(leaf.start + Vector2(sway, t * FALL_SPEED)).round()
		var frame=int(t / FRAME_TIME) % 4
		leaf.atlas.region=Rect2(frame * 5, leaf.color * 5, 5, 5)
		# apparition et disparition en douceur
		var alpha=clamp(t / 0.6, 0.0, 1.0) * clamp((leaf.duration - t) / 0.8, 0.0, 1.0)
		leaf.sprite.modulate.a=alpha
