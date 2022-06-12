extends Sprite

signal pushButton
signal releaseButton

var RADIUS=16


func _input(event):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			if position.distance_to(event.position) < RADIUS:
				emit_signal("pushButton")
		else:
			if position.distance_to(event.position) < RADIUS:
				emit_signal("releaseButton")
			
