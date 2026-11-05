extends "res://common/class/scene.gd"

# la salle se rejoue pour gagner de l'xp, mais les gemmes ne sont donnees qu'une fois
const GAME_SCENE="res://screens/bear-village/bevil-room.tscn"
const GEMS_REWARD=4

var hasAlreadyWon=false

func _ready():
	hasAlreadyWon=GlobalScenes.getParamForSceneOr(GAME_SCENE,"hasAlreadyWon",false)
	var dialogId=GlobalGame.TRAD_BEARVILLAGE_BEVILROOM_REPLAY if hasAlreadyWon else GlobalGame.TRAD_BEARVILLAGE_BEVILROOM_WIN
	$winRect/winDialog.addDiscussion( GlobalGame.getTraductionById(GlobalGame.TRAD_WORD_APICULTEUR),GlobalGame.getTraductionById(dialogId))
	win()


func win():
	$winRect.visible=true
	$winRect/winDialog.start()

	$Camera2D.enabled=true
	$Camera2D.make_current()





func _on_winDialog_discussionFinished():
	if !hasAlreadyWon:
		GlobalPlayer.addGems(GEMS_REWARD)
		GlobalScenes.saveParamForScene(GAME_SCENE,"hasAlreadyWon",true)

	GlobalPlayer.savePosition(Vector2(120,300))
	SceneTransition.change_scene("res://screens/bear-village.tscn")
