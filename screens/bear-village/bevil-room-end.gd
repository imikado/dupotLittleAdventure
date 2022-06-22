extends "res://common/class/scene.gd"


func _ready():

	$winRect/winDialog.addDiscussion( GlobalGame.getTraductionById(GlobalGame.TRAD_WORD_APICULTEUR),GlobalGame.getTraductionById(GlobalGame.TRAD_BEARVILLAGE_BEVILROOM_WIN))
	win()
	

func win():
	$winRect.visible=true
	$winRect/winDialog.start()
	
	$Camera2D.current=true
	
	



func _on_winDialog_discussionFinished():
	GlobalPlayer.addGems(4)
	
	GlobalPlayer.savePosition(Vector2(120,300))
	get_tree().change_scene("res://screens/bear-village.tscn")
