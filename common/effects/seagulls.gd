extends Node2D

# Mouettes qui traversent de temps en temps la zone de jeu, au-dessus des
# decors, avec leur ombre au sol. La zone est le ReferenceRect de la camera.

@export var area:NodePath
@export var texture:Texture2D
# nombre d'images de la planche (battement d'ailes)
@export var frames:=3
@export var delayMin:=6.0
@export var delayMax:=14.0

const SPEED_MIN=26.0
const SPEED_MAX=40.0
const FLAP_TIME=0.14
# hauteur de vol : l'ombre est dessinee plus bas
const SHADOW_OFFSET=Vector2(6, 30)

var rect:Rect2
var wait=0.0
var birds=[]

func _ready():
	z_index=20
	var ref:ReferenceRect=get_node_or_null(area)
	if ref==null or texture==null:
		set_process(false)
		return
	rect=Rect2(ref.global_position, ref.size)
	wait=randf_range(1.0, delayMax)

func _process(delta_):
	wait-=delta_
	if wait <= 0.0:
		wait=randf_range(delayMin, delayMax)
		spawn()
	for bird in birds.duplicate():
		bird.time+=delta_
		bird.position.x+=bird.speed * bird.direction * delta_
		var pos=Vector2(bird.position.x, bird.position.y + sin(bird.time * 2.0) * 3.0).round()
		bird.sprite.global_position=pos
		bird.shadow.global_position=pos + SHADOW_OFFSET
		# les ailes battent puis la mouette plane un moment
		var flapping=fmod(bird.time, 3.0) < 1.6
		bird.sprite.frame=int(bird.time / FLAP_TIME) % frames if flapping else 0
		if bird.position.x < rect.position.x - 40 or bird.position.x > rect.end.x + 40:
			bird.sprite.queue_free()
			bird.shadow.queue_free()
			birds.erase(bird)

func spawn():
	var direction=1 if randf() < 0.5 else -1
	var x=rect.position.x - 30 if direction==1 else rect.end.x + 30
	var y=randf_range(rect.position.y + 20, rect.end.y - 60)
	# parfois deux mouettes en vol groupe
	var count=2 if randf() < 0.35 else 1
	for i in count:
		var sprite=Sprite2D.new()
		sprite.texture=texture
		sprite.hframes=frames
		sprite.flip_h=direction==-1
		var shadow=Sprite2D.new()
		shadow.texture=texture
		shadow.hframes=frames
		shadow.frame=1
		shadow.flip_h=sprite.flip_h
		shadow.modulate=Color(0, 0, 0, 0.2)
		# ombre au niveau du sol, sous les personnages (noeud place avant eux)
		shadow.z_as_relative=false
		shadow.z_index=0
		add_child(shadow)
		add_child(sprite)
		birds.append({
			"sprite":sprite,
			"shadow":shadow,
			"position":Vector2(x - direction * i * 18, y + i * 12),
			"direction":direction,
			"speed":randf_range(SPEED_MIN, SPEED_MAX),
			"time":randf() * 3.0,
		})
