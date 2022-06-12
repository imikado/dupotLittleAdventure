extends Node2D


signal save
signal quit

signal startClimbing
signal endClimbing

signal digging
signal endDigging

signal hit(enemy_)
signal damagedBy(enemy_)

signal pressAccept
signal pressMenu

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func getPlayerPosition():
	return $player.global_position

func enableNavigation():
	$navigation.enable()

func disableNavigation():
	$navigation.disable()

	$player.stop()

func reloadGems():
	$HUD.reloadGems()
	
func reloadInvetory():
	$HUD.reloadInventory()
	
func reloadLife():
	$HUD.reloadLife()
	
func reloadXp():
	$HUD.reloadXp()

func zoomDown():
	$player.zoomDown()
	
func zoomUp():
	$player.zoomUp();
	
func loadCameraLimits(cameraRef_):
	$player.loadCameraLimits(cameraRef_)


func _on_shopList_buyItem(item_):
	$HUD.reloadGems()
	$HUD.reloadInventory()
	enableNavigation()


func _on_HUD_save():
	emit_signal("save")
	pass # Replace with function body.


func _on_HUD_quit():
	emit_signal("quit")
	pass # Replace with function body.


func _on_player_startClimbing():
	emit_signal("startClimbing")
	pass # Replace with function body.


func _on_player_endClimbing():
	emit_signal("endClimbing")
	pass # Replace with function body.


func _on_gordonhome_playerLeaveScale():
	$player._on_gordonhome_playerLeaveScale()
	pass # Replace with function body.


func _on_gordonhome_playerOnScale():
	$player._on_gordonhome_playerOnScale()
	pass # Replace with function body.


func _on_gordonhome_playerStartClimbing():
	$player._on_gordonhome_playerStartClimbing()
	pass # Replace with function body.




func _on_navigation_releaseButton():
	if GlobalPlayer.getEquipment()==GlobalItems.ID.SPADE:
		emit_signal("endDigging")
	
func _on_navigation_pushButton():
	if GlobalPlayer.getEquipment()==GlobalItems.ID.SPADE:
		emit_signal("digging")
	


func _on_player_hit(enemy_):
	emit_signal("hit",enemy_)



func _on_player_damagedBy(enemy_):
	emit_signal("damagedBy",enemy_)


func _on_HUD_useItem(item_):
	$HUD.reloadInventory()
	pass # Replace with function body.


func _on_player_pressAccept():
	emit_signal("pressAccept")
	pass # Replace with function body.


func _on_player_pressMenu():
	emit_signal("pressMenu")
	pass # Replace with function body.
