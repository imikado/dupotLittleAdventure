extends Area2D


signal placed(item_)

signal unPlaced(item_)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_placeholder_body_shape_entered(body_id, body, body_shape, area_shape):
	if body.is_in_group("sea-shell"):
		emit_signal("placed",body)


func _on_placeholder_body_shape_exited(body_id, body, body_shape, area_shape):
	if body.is_in_group("sea-shell"):
		emit_signal("unPlaced",body)
