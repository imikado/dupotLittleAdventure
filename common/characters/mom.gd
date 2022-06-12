extends StaticBody2D

signal talk 


func _ready():
	pass # Replace with function body.



func _on_talk_playerOpenedDoor():
	emit_signal("talk")
	pass # Replace with function body.
