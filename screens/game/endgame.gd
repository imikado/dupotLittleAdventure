extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	refreshUi()
	$Camera2D/AnimationPlayer.play("start")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_button_down():
	get_tree().change_scene("res://screens/game/menu.tscn")
	pass # Replace with function body.

func refreshUi():
	$Button.text=GlobalGame.getTraductionById(GlobalGame.TRAD_LABEL_RETOURAUMENU)
