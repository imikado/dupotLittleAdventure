extends CharacterBody2D

signal hit(enemy_)
signal damage

var speed=100

var left=false
var right=false
var up=false
var down=false
var buttonPressed=false

var useTouch=false


var limitLeft=0
var limitRight=0
var limitTop=0
var limitBottom=0

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
	var currentAnimation='walking-right'
	
	
	if buttonPressed:# && GlobalPlayer.getEquipment()==GlobalItems.ID.SPADE:
		currentAnimation='attack1-right'
	elif up :
		currentAnimation='walking-up'
		$AnimatedSprite2D.flip_h=true
	elif down :
		currentAnimation='walking-down'
		$AnimatedSprite2D.flip_h=false
	elif left:
		$AnimatedSprite2D.flip_h=true

	elif right:
		$AnimatedSprite2D.flip_h=false
	else:
		currentAnimation='idle'

	playAnimation(currentAnimation)


func playAnimation(anim):
	#$AnimatedSprite.play(anim)
	$AnimatedSprite2D/AnimationPlayer.play(anim)
	$AnimatedSprite2D.play()


func resetKeys():
	if useTouch:
		return
		
	left=false
	right=false
	up=false
	down=false


func animDamage():
	$redModulate.visible=true
	$TimerModulate.start()

#-----------events

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



func _on_navigation_releaseButton():
	buttonPressed=false
	pass # Replace with function body.


func _on_navigation_pushButton():
	buttonPressed=true



func _on_hit_body_shape_entered(body_id, body, body_shape, area_shape):
	if body.is_in_group("Enemy"):
		emit_signal("hit",body)
	


func _on_damage_body_shape_entered(body_id, body, body_shape, area_shape):
	if body.is_in_group("Enemy"):
		emit_signal("damage")
		animDamage()




func _on_TimerModulate_timeout():
	$redModulate.visible=false
	pass # Replace with function body.
