extends CharacterBody2D

# teinte d'un coquillage pose sur une croix
const PLACED_COLOR=Color(0.8, 1.0, 0.75)

var placed=false

func setPlaced(state_):
	if placed==state_:
		return
	placed=state_
	modulate=PLACED_COLOR if placed else Color.WHITE

func getPlaced():
	return placed

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("sea-shell")
	pass # Replace with function body.

func move(vel_):
	move_and_collide(vel_)
	#position+=vel_
