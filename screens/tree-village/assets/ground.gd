extends Area2D

signal rightGroundFounded
signal rightGroundFoundedLeft

signal isDiscovered

var discovered=false
var playerInside=false

# etincelle qui trahit une etoile enterree (grande et petite etoile en alternance)
const HINT_TEXTURE=preload("res://screens/tree-village/images/dig-hint.png")
const HINT_BLINK=0.25
var hint:Sprite2D
var hintTween:Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	hint=Sprite2D.new()
	hint.texture=HINT_TEXTURE
	hint.hframes=2
	hint.visible=false
	add_child(hint)

func enableDiscovered():
	discovered=true

func play():
	if !discovered:
		hideHint()
		$AnimatedSprite2D.play()

# pause et non stop : le trou garde son avancement entre deux coups de pelle
# (stop remettait l'animation a l'image 0, il fallait tout creuser d'un seul appui)
func stop():
	$AnimatedSprite2D.pause()
	if playerInside:
		showHint(false)

# avec la pelle, Gordon voit briller l'endroit ou creuser
func showHint(withSound_=true):
	if discovered or hint.visible or !GlobalPlayer.hasItem(GlobalItems.ID.SPADE):
		return
	hint.visible=true
	hint.frame=0
	if withSound_:
		Sfx.play(Sfx.CURSOR)
	if hintTween!=null:
		hintTween.kill()
	hintTween=create_tween().set_loops()
	hintTween.tween_property(hint, "frame", 1, 0).set_delay(HINT_BLINK)
	hintTween.tween_property(hint, "frame", 0, 0).set_delay(HINT_BLINK)

func hideHint():
	if hintTween!=null:
		hintTween.kill()
		hintTween=null
	hint.visible=false


func _on_ground_body_shape_entered(body_id, body, body_shape, area_shape):
	if body.is_in_group("Player"):
		playerInside=true
		showHint()
		emit_signal("rightGroundFounded")


func _on_ground_body_shape_exited(body_id, body, body_shape, area_shape):
	if body.is_in_group("Player"):
		playerInside=false
		hideHint()
		emit_signal("rightGroundFoundedLeft")


func _on_AnimatedSprite_animation_finished():
	discovered=true
	hideHint()
	emit_signal("isDiscovered")
	$AnimatedSprite2D.set_frame(0)
