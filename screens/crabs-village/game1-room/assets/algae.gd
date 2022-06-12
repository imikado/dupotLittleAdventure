extends Node2D

signal selected

var state=false

func isSelected():
	return state

func setSelected(state_):
	state=state_
	$ColorRect.visible=state_

	if state_:
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()

func _ready():
	setSelected(false)


func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch and event.is_pressed():
		emit_signal("selected")
	
