extends "res://common/class/scene.gd"

# Maman soigne Gordon quand il rentre fatigue
var shouldHeal=false

func _ready():
	setPlayerPath("Node2D/playerAndControl")
	loadPosition()
	getPlayer().zoomDown()
	getPlayer().loadCameraLimits($cameraRef)

	buildDiscussion()

func buildDiscussion():
	$simpleDialog.clearDiscussion()

	var TRAD_GORDONMOM=GlobalGame.getTraductionById(GlobalGame.TRAD_WORD_GORDONMOM)
	var TRAD_GORDON=GlobalGame.getTraductionById(GlobalGame.TRAD_WORD_GORDON)

	var discussionList=GlobalGame.getTraductionById(GlobalGame.TRAD_TREEVILLAGE_GORDONHOME)

	$simpleDialog.addDiscussion(TRAD_GORDONMOM,discussionList[0])
	$simpleDialog.addDiscussion(TRAD_GORDON,discussionList[1])
	$simpleDialog.addDiscussion(TRAD_GORDONMOM,discussionList[2])

	shouldHeal=GlobalPlayer.getLife() < GlobalPlayer.getMaxLife()
	if shouldHeal:
		$simpleDialog.addDiscussion(TRAD_GORDONMOM,GlobalGame.getTraductionById(GlobalGame.TRAD_TREEVILLAGE_GORDONHOME_HEAL))


func _on_door_playerOpenedDoor():
	GlobalPlayer.savePosition(Vector2(436,160))
	SceneTransition.change_scene("res://screens/tree-village.tscn")
	pass # Replace with function body.


func _on_mom_talk():
	$simpleDialog.start()
	getPlayer().disableNavigation()


func _on_simpleDialog_discussionFinished():
	$simpleDialog.end()
	if shouldHeal:
		GlobalPlayer.setLife(GlobalPlayer.getMaxLife())
		getPlayer().reloadLife()
		Sfx.play(Sfx.HEAL)
	buildDiscussion()
	getPlayer().enableNavigation()


func _on_playerAndControl_pressAccept():
	$simpleDialog.next()
	pass # Replace with function body.
