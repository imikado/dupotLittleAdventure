extends Control

var saveFileList=[]

func _ready():
	refreshUi()
	hideNewGame()
	hideLoadGame()
	
	$VBoxContainer/btnNew.grab_focus()
	
	saveFileList=GlobalGame.getList()
	 
	var popup=$loadGameBox/MenuButton.get_popup()
			
	if saveFileList.size()>0:
		for saveFile in saveFileList:
			popup.add_item(saveFile)
	
	popup.connect("id_pressed",self,"_on_press_fileToLoad")

func _on_press_fileToLoad(idFile_):
	var popup=$loadGameBox/MenuButton.get_popup()
	
	var fileSave=popup.get_item_text(idFile_)
	
	GlobalGame.loadFile(fileSave)
	get_tree().change_scene(GlobalGame.getSceneToLoad())

func _on_btnNew_button_down():
	showNewGame()
	hideLoadGame()

func _on_btnLoad_button_down():
	showLoadGame()
	hideNewGame()
	pass # Replace with function body.

func showNewGame():
	$newGameBox.visible=true
	$CanvasLayer/keyboard.visible=true
	$CanvasLayer/keyboard.reset()
	
	$CanvasLayer/keyboard/VBox/HBoxContainer/submit.grab_focus()

func hideNewGame():
	$newGameBox.visible=false	
	

func showLoadGame():
	$loadGameBox.visible=true

func hideLoadGame():
	$loadGameBox.visible=false	
	
func _on_btnCreate_button_down():
	GlobalGame.create($newGameBox/nicknameLabel.text)
	get_tree().change_scene(GlobalGame.getSceneToLoad())


func _on_keyboard_fillField(text_):
	$CanvasLayer/keyboard.visible=false
	$newGameBox/nicknameLabel.text=text_
	
	$newGameBox/btnCreate.grab_focus()
	pass # Replace with function body.


func _on_keyboard_close():
	$CanvasLayer/keyboard.visible=false


func _on_btnFR_button_down():
	GlobalGame.setLang(GlobalGame.FR)
	
	refreshUi()
	pass # Replace with function body.


func _on_btnEN_button_down():
	GlobalGame.setLang(GlobalGame.EN)
	
	refreshUi()
	pass # Replace with function body.

func refreshUi():
	$VBoxContainer/btnNew.text=GlobalGame.getTraductionById(GlobalGame.TRAD_BUTTON_NEWGAME)
	$VBoxContainer/btnLoad.text=GlobalGame.getTraductionById(GlobalGame.TRAD_BUTTON_LOADGAME)
	$newGameBox/btnCreate.text=GlobalGame.getTraductionById(GlobalGame.TRAD_BUTTON_CREATE)
	$newGameBox/Label.text=GlobalGame.getTraductionById(GlobalGame.TRAD_LABEL_NOM)
	$loadGameBox/MenuButton.text=GlobalGame.getTraductionById(GlobalGame.TRAD_LABEL_PARTIES)
