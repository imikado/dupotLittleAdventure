extends "res://common/class/scene.gd"


var shopItemClass=preload("res://common/class/shopItem_class.gd")



func _ready():
	setPlayerPath("playerAndControl")
	loadPosition()
	getPlayer().loadCameraLimits($cameraRef)
	
	$simpleDialog.addDiscussion(GlobalGame.getTraductionById(GlobalGame.TRAD_WORD_VENDEUR),GlobalGame.getTraductionById(GlobalGame.TRAD_CRABVILLAGE_SHOP))
		
	$shopList.setShopItemList([
		shopItemClass.new(GlobalItems.ID.NAILS,6),
		shopItemClass.new(GlobalItems.ID.HEALTH_POTION_10,50)
		])
	
	
	

func _on_simpleDialog_discussionFinished():
	$simpleDialog.end()
	$shopList.show()
	pass # Replace with function body.


func _on_sellerTalk_playerOpenedDoor():
	$simpleDialog.start()
	
	getPlayer().disableNavigation()



func _on_door_playerOpenedDoor():
	GlobalPlayer.savePosition(Vector2(45,171))
	get_tree().change_scene("res://screens/crabs-village.tscn")

