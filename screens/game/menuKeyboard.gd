extends Control



# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$CanvasLayer/keyboard.reset()
	
	


func _on_keyboard_close():
	SceneTransition.change_scene("res://screens/game/menu.tscn")	

func _on_keyboard_fillField(text_):
	# il faut un pseudo pour nommer la sauvegarde
	if text_.strip_edges()=="":
		Sfx.play(Sfx.MISS)
		return
	GlobalGame.create(text_)
	SceneTransition.change_scene(GlobalGame.getSceneToLoad())
	return

	
