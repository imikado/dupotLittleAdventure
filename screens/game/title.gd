extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayerLittle.play("New Anim")
	$AnimationPlayerAdventure.play("New Anim")
	
	var keyboardOsList=["HTML5","Web","X11","Linux", "FreeBSD", "NetBSD", "OpenBSD", "BSD","Windows"]

	var osName= OS.get_name()
	#print(osName)
	if(keyboardOsList.find(osName)!=-1):
		GlobalPlayer.disableTouch()
		GlobalPlayer.disableDialogAnimation()
		pass
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	
	get_tree().change_scene("res://screens/game/menu.tscn")
	pass # Replace with function body.
