extends Control

func _ready(): 
	get_tree().set_screen_stretch(
		SceneTree.STRETCH_MODE_2D,
		SceneTree.STRETCH_ASPECT_KEEP,
		Vector2(900,800))
