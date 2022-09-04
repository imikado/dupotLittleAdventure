extends Control



# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$CanvasLayer/keyboard.reset()
	
	


func _on_keyboard_close():
	get_tree().change_scene("res://screens/game/menu.tscn")	

func _on_keyboard_fillField(text_):
	
	GlobalGame.create(text_)
	get_tree().change_scene(GlobalGame.getSceneToLoad())
	return

	
