extends "res://common/class/scene.gd"


var nbBeeKilled=0
var maxNbBeeToKill=0


func debug():
	GlobalPlayer.addItem(GlobalItems.ID.WOOD_SWORD)
	GlobalPlayer.setEquipment((GlobalItems.ID.WOOD_SWORD))



func _ready():
	#debug()

	$startRect/startDialog.addDiscussion( GlobalGame.getTraductionById(GlobalGame.TRAD_WORD_APICULTEUR),GlobalGame.getTraductionById(GlobalGame.TRAD_BEARVILLAGE_BEVILROOM_START))
	$startRect/startDialog.start()
	
	

	


func startGame():
	get_tree().change_scene("res://screens/bear-village/bevil-room-game.tscn")



func _on_startDialog_discussionFinished():
	startGame()
