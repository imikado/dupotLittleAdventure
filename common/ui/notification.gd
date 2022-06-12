extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$canvas/ColorRect.visible=false
	pass # Replace with function body.

func display(text_):
	$canvas/ColorRect/Label.text=text_
	$canvas/ColorRect.visible=true

	$Timer.start()


func _on_Timer_timeout():
	$canvas/ColorRect.visible=false
	pass # Replace with function body.
