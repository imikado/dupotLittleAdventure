extends CharacterBody2D


var speed=100

var left=false
var right=false
var up=false
var down=false
var buttonPressed=false

var useTouch=false

var maxSpeed=300
const GRAVITY = 350
const ACCEL=100
const JUMPHEIGHT=150

var limitLeft=0
var limitRight=0
var limitTop=0
var limitBottom=0

var vel= Vector2()

var state=IDLE

var filled=false

enum {IDLE,WALK,JUMP,JUMP_DOWN,HURT,DEAD}

var current_animation="idle"

@export var refRect : Rect2

func enableCamera():
	$Camera2D.enabled=true
	$Camera2D.make_current()

func disableCamera():
	$Camera2D.enabled=false

func loadCameraLimits(refRect:ReferenceRect):
	
	var refPosition=refRect.global_position
	var rect=refRect.size + refPosition
	
	limitLeft=refPosition.x
	limitTop=refPosition.y
	limitRight=rect.x
	limitBottom=rect.y
	
	$Camera2D.limit_left=limitLeft
	$Camera2D.limit_top=limitTop
	$Camera2D.limit_right=limitRight
	$Camera2D.limit_bottom=limitBottom
	

func resetZoom():
	$Camera2D.zoom=Vector2(1,1)

func zoomDown():
	# Godot 4 : zoom inverse de Godot 3 (0.7 en Godot 3)
	var zoom=1.0/0.7
	$Camera2D.zoom=Vector2(zoom,zoom)
	
func zoomUp():
	# Godot 4 : zoom inverse de Godot 3 (2 en Godot 3)
	var zoom=0.5
	$Camera2D.zoom=Vector2(zoom,zoom)
	
func _ready():
	add_to_group("Player")
	#loadCameraLimits()
	resetZoom()

func isFilled():
	return filled

func fill():
	filled=true

func is_empty():
	filled=false


func state_loop():
	#print (state)
	var new_state=calculateNewState(state,vel,is_on_floor())
	
	if new_state!=state:
		change_state(new_state)

func calculateNewState(state_,velocity_,is_on_floor_):

	if state_ in [IDLE] and (velocity_.x >1 or velocity_.x <-1):
		return WALK
	elif state_ in [IDLE,WALK] and !is_on_floor_:
		return JUMP
	elif state_ in [IDLE,WALK] and (velocity_.x > -1 and velocity_.x < 1):
		return IDLE
	elif state_ in [JUMP] and is_on_floor_:
		return IDLE
	else:
		return state_

func setState(state_):
	state=state_		

func change_state(new_state) -> void:

	var suffix=''
	
	if isFilled():
		suffix="-filled"

	state=new_state
	match state:
		IDLE:
			animationPlay("idle"+suffix)
		WALK:
			animationPlay("walking"+suffix)
		JUMP:
			animationPlay("jumping"+suffix)

func animationPlay(animation : String) -> void:
	if current_animation!= animation:
		$AnimatedSprite2D.play(animation)
	
		current_animation=animation



func _physics_process(delta):
	
	pocessInput()
	
	state_loop()
	
	$AnimatedSprite2D.flip_h=false


	if left:
		$AnimatedSprite2D.flip_h=true
		vel.x = max(vel.x-ACCEL*delta,-maxSpeed)
	elif right:


		vel.x = min(vel.x+ACCEL*delta,maxSpeed)
	else:
		vel.x=lerpf(vel.x,0,0.10)
	
	if buttonPressed && is_on_floor():
		vel.y=-JUMPHEIGHT
		buttonPressed=false
	
	vel.y+=GRAVITY*delta
	

	set_velocity(vel)
	set_up_direction(Vector2(0,-1))
	move_and_slide()
	vel=velocity
	
	resetKeys()
	




func pocessInput():
	if Input.is_action_pressed("ui_right"):
		right=true
		useTouch=false
	if Input.is_action_pressed("ui_left"):
		left=true
		useTouch=false
	if Input.is_action_pressed("ui_down"):
		down=true
		useTouch=false
	if Input.is_action_pressed("ui_up"):
		up=true
		useTouch=false

	if Input.is_action_just_pressed("ui_accept"):
		buttonPressed=true
		useTouch=false
 


func playAnimation(anim):
	$AnimatedSprite2D.play(anim)
	#$AnimatedSprite/AnimationPlayer.play()


func resetKeys():
	if useTouch:
		return
		
	left=false
	right=false
	up=false
	down=false


func _on_navigation_movePlayer(joystickVector_):
	useTouch=true
	
	right=false
	left=false
	down=false
	up=false	
	
	if abs(joystickVector_.x)>abs(joystickVector_.y) :
	
		if(joystickVector_.x > 10):
			right=true
		elif(joystickVector_.x < -10):
			left=true
	 
	else:
				
		if(joystickVector_.y > 10):
			down=true
		elif(joystickVector_.y < -10):
			up=true
			

func _on_navigation_pushButton():
	buttonPressed=true



func _on_navigation_releaseButton():
	buttonPressed=false
