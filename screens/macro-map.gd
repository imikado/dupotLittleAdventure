extends "res://common/class/scene.gd"


func _ready():
	
	setPlayerPath("playerAndControl")
	loadPosition()
	getPlayer().zoomUp()
	getPlayer().loadCameraLimits($cameraRef)
 

func _on_crabvillage_playerOpenedDoor():
	GlobalPlayer.savePosition(Vector2(79,168))
	get_tree().change_scene("res://screens/crabs-village.tscn")


func _on_treevillage2_playerOpenedDoor():
	GlobalPlayer.savePosition(Vector2(900,258))
	get_tree().change_scene("res://screens/tree-village.tscn")
	pass # Replace with function body.


func _on_bearvillage2_playerOpenedDoor():
	GlobalPlayer.savePosition(Vector2(964,427))
	get_tree().change_scene("res://screens/bear-village.tscn")


func _on_spiderattackdown_playerOpenedDoor():
	GlobalPlayer.savePosition(getPlayer().getPlayerPosition())
	GlobalPlayer.setSide("DOWN")
	get_tree().change_scene("res://screens/macro-map/spiderFight.tscn") # Replace with function body.


func _on_spiderattackupa_playerOpenedDoor():
	GlobalPlayer.savePosition(getPlayer().getPlayerPosition())
	GlobalPlayer.setSide("UP")
	get_tree().change_scene("res://screens/macro-map/spiderFight.tscn")

