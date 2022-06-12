extends KinematicBody2D

signal goLeft(id_)
signal goRight(id_)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch and event.is_pressed():
		emit_signal("goLeft",self)


func _on_Area2D2_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch and event.is_pressed():
		emit_signal("goRight",self)
