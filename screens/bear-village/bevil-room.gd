extends "res://common/class/scene.gd"


var nbBeeKilled=0
var maxNbBeeToKill=0


func debug():
	GlobalPlayer.addItem(GlobalItems.ID.WOOD_SWORD)
	GlobalPlayer.setEquipment((GlobalItems.ID.WOOD_SWORD))



func _ready():
	#debug()

	setPlayerPath("playerAndControl")
	loadPosition()
	
	getPlayer().disableNavigation()
	
	setupGame()
	
	$startRect/startDialog.addDiscussion( GlobalGame.getTraductionById(GlobalGame.TRAD_WORD_APICULTEUR),GlobalGame.getTraductionById(GlobalGame.TRAD_BEARVILLAGE_BEVILROOM_START))
	$startRect/startDialog.start()
	
	$startRect.visible=true
	
	$winRect/winDialog.addDiscussion( GlobalGame.getTraductionById(GlobalGame.TRAD_WORD_APICULTEUR),GlobalGame.getTraductionById(GlobalGame.TRAD_BEARVILLAGE_BEVILROOM_WIN))
	$winRect.visible=false
	
func setupGame():
	for node in get_children():
		if node.is_in_group("Enemy"):
			node.setPlayer(getPlayer())
			
			maxNbBeeToKill+=1

func startGame():
	getPlayer().loadCameraLimits($cameraRef)

	



func _on_playerAndControl_hit(enemy_):
	enemy_.queue_free()
	GlobalPlayer.addXp(2)
	nbBeeKilled+=1
	$playerAndControl.reloadXp()
	
	if nbBeeKilled==maxNbBeeToKill:
		win()
	

func win():
	$winRect.visible=true
	$winRect/winDialog.start()
	
	$Camera2D.current=true
	
	$playerAndControl.disableNavigation()
	

func _on_playerAndControl_damagedBy(enemy_):
	
	enemy_.goBack()
	
	GlobalPlayer.damage(10)
	getPlayer().reloadLife()


func _on_startDialog_discussionFinished():
	$startRect/startDialog.end()
	$startRect.visible=false
	$playerAndControl.enableNavigation()
	$Camera2D.current=false
	
	startGame()
	pass # Replace with function body.


func _on_winDialog_discussionFinished():
	GlobalPlayer.addGems(4)
	
	GlobalPlayer.savePosition(Vector2(120,300))
	get_tree().change_scene("res://screens/bear-village.tscn")
