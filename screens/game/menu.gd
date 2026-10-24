extends Control

var saveFileList=[]

func _ready():
	refreshUi()
	
	get_node("version").text=GlobalVersion.getVersion()

	$VBoxContainer/btnNew.grab_focus()


func _on_btnNew_button_down():
	#showNewGame()
	#hideLoadGame()
	SceneTransition.change_scene("res://screens/game/menuKeyboard.tscn")
	

func _on_btnLoad_button_down():
	#showLoadGame()
	#hideNewGame()
	SceneTransition.change_scene("res://screens/game/menuLoad.tscn")
	pass # Replace with function body.








func _on_btnFR_button_down():
	GlobalGame.chooseLang(GlobalGame.FR)
	
	refreshUi()
	pass # Replace with function body.


func _on_btnEN_button_down():
	GlobalGame.chooseLang(GlobalGame.EN)
	
	refreshUi()
	pass # Replace with function body.

func refreshUi():
	$VBoxContainer/btnNew.text=GlobalGame.getTraductionById(GlobalGame.TRAD_BUTTON_NEWGAME)
	$VBoxContainer/btnLoad.text=GlobalGame.getTraductionById(GlobalGame.TRAD_BUTTON_LOADGAME)
	# la langue active est en surbrillance, l'autre est estompée
	$lang/btnFR.modulate.a=1.0 if GlobalGame.getLang()==GlobalGame.FR else 0.5
	$lang/btnEN.modulate.a=1.0 if GlobalGame.getLang()==GlobalGame.EN else 0.5
	
