extends Area2D

signal rightGroundFounded
signal rightGroundFoundedLeft

signal isDiscovered

var discovered=false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func enableDiscovered():
	discovered=true
	
func play():
	if !discovered:
		$AnimatedSprite.play()

func stop():
	$AnimatedSprite.stop()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ground_body_shape_entered(body_id, body, body_shape, area_shape):
	if body.is_in_group("Player"):
		emit_signal("rightGroundFounded")
	pass # Replace with function body.


func _on_ground_body_shape_exited(body_id, body, body_shape, area_shape):
	if body.is_in_group("Player"):
		emit_signal("rightGroundFoundedLeft")
	pass # Replace with function body.


func _on_AnimatedSprite_animation_finished():
	discovered=true
	emit_signal("isDiscovered")
	$AnimatedSprite.set_frame(0)
	pass # Replace with function body.
