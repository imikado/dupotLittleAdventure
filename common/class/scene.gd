extends Node2D

var playerPath=null

func setPlayerPath(playerPath_):
	playerPath=playerPath_

func loadPosition():
	if(GlobalPlayer.shouldLoadPosition()):
		getPlayer().position=GlobalPlayer.loadPosition()
		print("load position")
	else:
		print("not load pisition")
		
func getPlayer():
	return get_node(playerPath)


func _on_playerAndControl_quit():
	print( "reel quitter gotoMenu")
	GlobalGame.gotoMenu()
	

func _on_playerAndControl_save():
	GlobalGame.saveWithPosition(filename,getPlayer().getPlayerPosition());
	
