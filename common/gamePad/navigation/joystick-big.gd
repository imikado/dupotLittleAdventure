extends Sprite

signal moveJoystick(joystickVector)

const RADIUS = 32
const SMALL_RADIUS = 16

var joystick_pos;
var isPressed=false

#access
func getSmall():
	return $"joystick-small"

func _init():
	joystick_pos = position;

func _input(event_):
	if event_ is InputEventScreenTouch:
		if event_.is_pressed():
			if joystick_pos.distance_to(event_.position) < RADIUS:
				isPressed=true
			
		else:
			isPressed=false
			getSmall().position=Vector2()
			emit_signal("moveJoystick",getSmall().position)
			
	if isPressed and event_ is InputEventScreenDrag:
		var joystickDistance= joystick_pos.distance_to(event_.position)
		var joystickVector=(event_.position - joystick_pos).normalized()
		
		if joystickDistance + SMALL_RADIUS > RADIUS:
			joystickDistance = RADIUS - SMALL_RADIUS
			
		getSmall().position=joystickVector*joystickDistance 
		emit_signal("moveJoystick",getSmall().position)
	
