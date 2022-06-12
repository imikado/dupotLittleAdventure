extends "res://common/class/scene.gd"


func _ready():
	setPlayerPath("YSort/playerAndControl")
	loadPosition()
	getPlayer().zoomDown()
	getPlayer().loadCameraLimits($cameraRef)

	var TRAD_GORDONMOM=GlobalGame.getTraductionById(GlobalGame.TRAD_WORD_GORDONMOM)

	var discussionList=GlobalGame.getTraductionById(GlobalGame.TRAD_TREEVILLAGE_GORDONHOME)
	
	$simpleDialog.addDiscussion(TRAD_GORDONMOM,discussionList[0])
	$simpleDialog.addDiscussion("Gordon",discussionList[1])
	$simpleDialog.addDiscussion(TRAD_GORDONMOM,discussionList[2])


func _on_door_playerOpenedDoor():
	GlobalPlayer.savePosition(Vector2(436,160))
	get_tree().change_scene("res://screens/tree-village.tscn")
	pass # Replace with function body.


func _on_mom_talk():
	$simpleDialog.start()
	getPlayer().disableNavigation()


func _on_simpleDialog_discussionFinished():
	$simpleDialog.end()
	getPlayer().enableNavigation()


func _on_playerAndControl_pressAccept():
	$simpleDialog.next()
	pass # Replace with function body.
