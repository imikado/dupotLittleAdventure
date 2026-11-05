extends "res://common/class/scene.gd"


var shopItemClass=preload("res://common/class/shopItem_class.gd")



func _ready():
	setPlayerPath("playerAndControl")
	loadPosition()
	getPlayer().loadCameraLimits($cameraRef)
	
	$simpleDialog.addDiscussion(GlobalGame.getTraductionById(GlobalGame.TRAD_WORD_VENDEUR),GlobalGame.getTraductionById(GlobalGame.TRAD_BEARVILLAGE_SHOP))
		
	$shopList.setShopItemList([
		shopItemClass.new(GlobalItems.ID.HONEY,5),
		shopItemClass.new(GlobalItems.ID.HEALTH_POTION_10,8),
		shopItemClass.new(GlobalItems.ID.BUCKET,3)
		])
	
	


func _on_sellerTalk_playerOpenedDoor():
	$simpleDialog.start()
	
	getPlayer().disableNavigation()
	
	


func _on_door_playerOpenedDoor():
	GlobalPlayer.savePosition(Vector2(833,458))
	SceneTransition.change_scene("res://screens/bear-village.tscn")


func _on_simpleDialog_discussionFinished():
	$simpleDialog.end()
	$shopList.showWindow()
