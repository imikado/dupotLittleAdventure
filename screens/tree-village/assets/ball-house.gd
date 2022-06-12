extends StaticBody2D

signal playerEntered

func _ready():
	pass # Replace with function body.


func _on_door_playerOpenedDoor():
	emit_signal("playerEntered")
	pass # Replace with function body.
