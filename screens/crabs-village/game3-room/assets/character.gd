extends CharacterBody2D


var speed=100

var left=false
var right=false
var up=false
var down=false

var useTouch=false


var limitLeft=0
var limitRight=0
var limitTop=0
var limitBottom=0


@export var refRect : Rect2

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

func enableCamera():
	$Camera2D.enabled=true
	$Camera2D.make_current()
	
func disableCamera():
	$Camera2D.enabled=false

func _ready():
	add_to_group("Character")
	
func _process(delta):
	
	pocessInput()
	
	var motion = Vector2()  # The player's movement vector.
	
	if left:
		motion.x -= 1
	elif right:
		motion.x += 1
	elif up:
		motion.y -= 1	
	elif down:
		motion.y += 1
	
	var velocityMin=motion	
		
	if motion.length() > 0:
		motion = motion.normalized() * speed
	
	var expectPosition=global_position+velocityMin
	

	if expectPosition.x < limitRight && expectPosition.x > limitLeft && expectPosition.y > limitTop && expectPosition.y < limitBottom: 	
		set_velocity(motion)
		move_and_slide()
		
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			
			if collision.get_collider().has_method("move"):
				collision.get_collider().move(velocityMin)
			
			#print("I collided with ", collision.get_collider().name)
	
	processAnimation()
	
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


func processAnimation():
	var currentAnimation="default"

	
	if up :
		currentAnimation='walk-up'
		$AnimatedSprite2D.flip_h=true
	elif down :
		currentAnimation='walk-down'
		$AnimatedSprite2D.flip_h=false
	elif left:
		currentAnimation='walk-right'
		
		$AnimatedSprite2D.flip_h=true

	elif right:
		currentAnimation='walk-right'
		$AnimatedSprite2D.flip_h=false
	else:
		currentAnimation="default"

	playAnimation(currentAnimation)


func playAnimation(anim):
	$AnimatedSprite2D.play(anim)
	$AnimatedSprite2D.play()


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

