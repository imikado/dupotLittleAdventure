extends StaticBody2D

signal playerStartClimbing
signal playerEndClimbing
signal playerOnScale
signal playerLeaveScale
signal playerEntered

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func _on_scale_body_shape_entered(body_id, body, body_shape, area_shape):
	if(body.is_in_group("Player")):
		emit_signal("playerOnScale")

func _on_scale_body_shape_exited(body_id, body, body_shape, area_shape):
	if(body.is_in_group("Player")):
		emit_signal("playerLeaveScale")


func _on_scaleBegin_playerOpenedDoor():
	emit_signal("playerStartClimbing")

func _on_scaleBegin_body_shape_exited(body_id, body, body_shape, area_shape):
	emit_signal("playerEndClimbing")


func _on_door_playerOpenedDoor():
	emit_signal("playerEntered")




