extends "res://common/class/scene.gd"


var nbBeeKilled=0
var maxNbBeeToKill=0

var playerSavedLife=0


func debug():
	GlobalPlayer.addItem(GlobalItems.ID.WOOD_SWORD)
	GlobalPlayer.setEquipment((GlobalItems.ID.WOOD_SWORD))



func _ready():
	#debug()
	
	playerSavedLife=GlobalPlayer.getLife()

	setPlayerPath("playerAndControl")
	loadPosition()
		
	setupGame()
	
	getPlayer().loadCameraLimits($cameraRef)

	$playerAndControl.enableNavigation()
	
	
func setupGame():
	for node in get_children():
		if node.is_in_group("Enemy"):
			node.setPlayer(getPlayer())
			
			maxNbBeeToKill+=1

func _on_playerAndControl_hit(enemy_):
	enemy_.queue_free()
	GlobalPlayer.addXp(2)
	nbBeeKilled+=1
	$playerAndControl.reloadXp()
	
	if nbBeeKilled==maxNbBeeToKill:
		win()
	

func win():
	get_tree().change_scene("res://screens/bear-village/bevil-room-end.tscn")
	

func _on_playerAndControl_damagedBy(enemy_):
	
	enemy_.goBack()
	
	GlobalPlayer.damage(10)
	getPlayer().reloadLife()

	if( GlobalPlayer.getLife() <= 0):
		GlobalPlayer.setLife(playerSavedLife)
		
		GlobalPlayer.savePosition(Vector2(120,300))
		get_tree().change_scene("res://screens/bear-village.tscn")



func _on_winDialog_discussionFinished():
	GlobalPlayer.addGems(4)
	
	GlobalPlayer.savePosition(Vector2(120,300))
	get_tree().change_scene("res://screens/bear-village.tscn")
