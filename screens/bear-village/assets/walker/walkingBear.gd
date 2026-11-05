extends AnimatableBody2D

# Ours d'ambiance qui se promene : il fait des allers-retours sur une ligne
# horizontale (de `fromX` a `toX`, en coordonnees locales a son depart), avec
# des pauses de face. Il s'arrete aussi quand Gordon est tout pres, pour ne
# jamais le pousser. Animations construites dans le code depuis les planches.

const SPEED=30.0
const STOP_DISTANCE=30.0
# idle : respiration, clignement, puis il se gratte le ventre (images 3 et 4)
const IDLE_FRAMES=[[0, 8.0], [1, 8.0], [0, 4.0], [2, 1.2], [0, 4.0], [3, 1.2], [4, 1.2], [3, 1.2], [4, 1.2], [3, 1.2], [4, 1.2], [0, 6.0]]

@export var idleSheet:Texture2D
@export var walkSheet:Texture2D
@export var fromX:=-80.0
@export var toX:=80.0

var startX=0.0
var direction=1.0
var pause=0.0
var player=null

func _ready():
	sync_to_physics=false
	startX=position.x
	var frames=SpriteFrames.new()
	frames.remove_animation("default")
	frames.add_animation("idle")
	frames.set_animation_speed("idle", 10)
	for frame in IDLE_FRAMES:
		frames.add_frame("idle", cut(idleSheet, frame[0]), frame[1])
	frames.add_animation("walk")
	frames.set_animation_speed("walk", 6)
	for i in walkSheet.get_width() / 32:
		frames.add_frame("walk", cut(walkSheet, i))
	$sprite.sprite_frames=frames
	pause=randf_range(0.5, 3.0)
	$sprite.play("idle")
	$sprite.frame=randi() % frames.get_frame_count("idle")

func cut(sheet_, index_):
	var atlas=AtlasTexture.new()
	atlas.atlas=sheet_
	atlas.region=Rect2(index_ * 32, 0, 32, 32)
	return atlas

func _physics_process(delta):
	if player==null:
		player=get_tree().get_first_node_in_group("Player")
	var near=player!=null and player.global_position.distance_to(global_position) < STOP_DISTANCE
	if near or pause > 0.0:
		pause-=delta
		if $sprite.animation!="idle":
			$sprite.play("idle")
		return
	if $sprite.animation!="walk":
		$sprite.play("walk")
	$sprite.flip_h=direction < 0.0
	position.x+=direction * SPEED * delta
	var x=position.x - startX
	if (direction > 0.0 and x >= toX) or (direction < 0.0 and x <= fromX):
		position.x=startX + (toX if direction > 0.0 else fromX)
		direction=-direction
		pause=randf_range(2.0, 5.0)
	elif randf() < delta * 0.08:
		# pause au milieu du chemin, de temps en temps
		pause=randf_range(1.5, 3.5)
