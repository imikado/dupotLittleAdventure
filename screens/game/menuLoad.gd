extends Control


var saveFileList=[]

onready var expleButton=get_node("exples/Button")

# Called when the node enters the scene tree for the first time.
func _ready():
	
	$exples.visible=false
	
	saveFileList=GlobalGame.getList()
	
	var buttonBox=get_node("scroll/VBox")
	
	if saveFileList.size()>0:
		for saveFileLoop in saveFileList:
			#popup.add_item(saveFile)
			var newButton=expleButton.duplicate()
			newButton.text=saveFileLoop
			
			buttonBox.add_child(newButton)
			
			newButton.connect("pressed",self,"_on_press_fileToLoad",[saveFileLoop])
	
	
	
	pass # Replace with function body.


func _on_press_fileToLoad(fileSave):

	
	GlobalGame.loadFile(fileSave)
	get_tree().change_scene(GlobalGame.getSceneToLoad())


func _on_Retour_pressed():
	get_tree().change_scene("res://screens/game/menu.tscn")
	pass # Replace with function body.
