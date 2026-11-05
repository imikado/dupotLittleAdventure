extends "res://common/class/scene.gd"


var shopItemClass=preload("res://common/class/shopItem_class.gd")

func _ready():
	setPlayerPath("playerAndControl")
	loadPosition()
	getPlayer().zoomDown()
	getPlayer().loadCameraLimits($cameraRef)

	var TRAD_WORD_VENDEUR=GlobalGame.getTraductionById(GlobalGame.TRAD_WORD_VENDEUR)

	var discussionList=GlobalGame.getTraductionById(GlobalGame.TRAD_TREEVILLAGE_SHOP)
	
	$simpleDialog.addDiscussion(TRAD_WORD_VENDEUR,discussionList[0])
	$simpleDialog.addDiscussion(GlobalGame.getTraductionById(GlobalGame.TRAD_WORD_GORDON),discussionList[1])
	$simpleDialog.addDiscussion(TRAD_WORD_VENDEUR,discussionList[2])
	
	$shopList.setShopItemList([
		shopItemClass.new(GlobalItems.ID.WOOD_SWORD,10),
		shopItemClass.new(GlobalItems.ID.IRON_SWORD,20),
		shopItemClass.new(GlobalItems.ID.HEALTH_POTION_10,8),
	])

func _on_door_playerOpenedDoor():
	GlobalPlayer.savePosition(Vector2(260,196))
	SceneTransition.change_scene("res://screens/tree-village.tscn")


func _on_discussionDoor_playerOpenedDoor():
	$simpleDialog.start()
	getPlayer().disableNavigation()


func _on_simpleDialog_discussionFinished():
	$simpleDialog.end()
	# Gordon reste immobile tant que la boutique est ouverte (buyItem le libere)
	$shopList.showWindow()


func _on_discussionArea_playerOpenedDoor():
	$simpleDialog.start()
	getPlayer().disableNavigation()


