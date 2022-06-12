extends "res://common/class/scene.gd"


var shopItemClass=preload("res://common/class/shopItem_class.gd")



func _ready():
	setPlayerPath("playerAndControl")
	loadPosition()
	getPlayer().loadCameraLimits($cameraRef)
	
	$simpleDialog.addDiscussion("vendeur",[
		"Bonjour,",
		"Choisi parmi nos produits",
		"Celui de ton choix"
		])
		
	$shopList.setShopItemList([
		shopItemClass.new(GlobalItems.ID.HONEY,6),
		shopItemClass.new(GlobalItems.ID.HEALTH_POTION_10,50)
		])
	
	


func _on_sellerTalk_playerOpenedDoor():
	$simpleDialog.start()
	
	getPlayer().disableNavigation()
	
	


func _on_door_playerOpenedDoor():
	GlobalPlayer.savePosition(Vector2(833,458))
	get_tree().change_scene("res://screens/bear-village.tscn")


func _on_simpleDialog_discussionFinished():
	$simpleDialog.end()
	$shopList.show()
