extends Node2D

var playerPath=null

func setPlayerPath(playerPath_):
	playerPath=playerPath_

func loadPosition():
	if(GlobalPlayer.shouldLoadPosition()):
		getPlayer().position=GlobalPlayer.loadPosition()
		
func getPlayer():
	return get_node(playerPath)


func _on_playerAndControl_quit():
	GlobalGame.gotoMenu()
	

func _on_playerAndControl_save():
	GlobalGame.saveWithPosition(scene_file_path,getPlayer().getPlayerPosition());
	
