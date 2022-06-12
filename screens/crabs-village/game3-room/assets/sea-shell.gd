extends KinematicBody2D

var placed=false

func setPlaced(state_):
	placed=state_
	
	print ("placed:")
	print(state_)

func getPlaced():
	return placed

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("sea-shell")
	pass # Replace with function body.

func move(vel_):
	move_and_collide(vel_)
	#position+=vel_
