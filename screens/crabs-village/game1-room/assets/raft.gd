extends Node2D

signal selected
signal goLeft
signal goRight

var itemSelected=null

enum item{ ALGAE,ASTONISHED,CRAB,RAFT}

func setSelected(state_):
	$ColorRect.visible=state_


func _ready():
	setSelected(false)
	setItem(null)
	
func setItem(item_):
	itemSelected=item_
	if itemSelected==item.ALGAE:
		$item.visible=true
		$item.play("algae")
	elif itemSelected==item.CRAB:
		$item.visible=true
		$item.play("crab")
	elif itemSelected==item.ASTONISHED:
		$item.visible=true
		$item.play("astonished")
		
	else:
		$item.visible=false
		

func getItem():
	return itemSelected

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch and event.is_pressed():
		emit_signal("selected")
	


func _on_left_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch and event.is_pressed():
		emit_signal("goLeft")


func _on_right_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch and event.is_pressed():
		emit_signal("goRight")
