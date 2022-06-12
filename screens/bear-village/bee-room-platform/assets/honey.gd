extends Area2D

signal playerPickHoney(obj_)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_honey_body_shape_entered(body_id, body, body_shape, area_shape):
	if body.is_in_group("Player") and body.isFilled()==false:
		emit_signal("playerPickHoney",self)
