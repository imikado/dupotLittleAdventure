extends Control


@onready var btnCreate=get_node("Control/btnCreate")
@onready var label=get_node("Control/Label")
@onready var nicknameInput=get_node("Control/nicknameLabel")


# Called when the node enters the scene tree for the first time.
func _ready():
	
	btnCreate.text=GlobalGame.getTraductionById(GlobalGame.TRAD_BUTTON_CREATE)
	label.text=GlobalGame.getTraductionById(GlobalGame.TRAD_LABEL_NOM)
	
	var clipboard=GlobalScenes.getClipboard()
	nicknameInput.text=clipboard if clipboard!=null else ""
	
	$Control/btnCreate.grab_focus()
	

func _on_btnCreate_button_down():
	GlobalGame.create(nicknameInput.text)
	SceneTransition.change_scene(GlobalGame.getSceneToLoad())
	
