extends KinematicBody2D

signal goLeft(id_)
signal goRight(id_)

export(bool) var displayDriver


# Called when the node enters the scene tree for the first time.
func _ready():
	$driver.visible=displayDriver
	

func _on_left_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch and event.is_pressed():
		emit_signal("goLeft",self)

func _on_right_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch and event.is_pressed():
		emit_signal("goRight",self)
