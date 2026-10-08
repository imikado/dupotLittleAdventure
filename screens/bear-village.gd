extends "res://common/class/scene.gd"

func debug():
	GlobalPlayer.addItem(GlobalItems.ID.WOOD_SWORD)



func _ready():
	setPlayerPath("Node2D/playerAndControl")
	loadPosition()
	getPlayer().loadCameraLimits($cameraRef)

	#debug()


func _on_bevilroom_playerEntered():
	SceneTransition.change_scene("res://screens/bear-village/bevil-room.tscn")


func _on_beeroom_playerEntered():
	SceneTransition.change_scene("res://screens/bear-village/bee-village-platform.tscn")


func _on_shop_playerEntered():
	SceneTransition.change_scene("res://screens/bear-village/shop.tscn")


func _on_gotToMacro_playerOpenedDoor():
	GlobalPlayer.savePosition(Vector2(168,-82))
	SceneTransition.change_scene("res://screens/macro-map.tscn")
