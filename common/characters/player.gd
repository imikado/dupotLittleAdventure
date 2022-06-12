extends KinematicBody2D

signal startClimbing
signal endClimbing

signal hit(enemy_)
signal damagedBy(enemy_)

signal pressAccept
signal pressMenu

var speed=100

var left=false
var right=false
var up=false
var down=false
var buttonPressed=false

var useTouch=false

var startClimbing=false
var onScale=false
var isClimbing=false

var limitLeft=0
var limitRight=0
var limitTop=0
var limitBottom=0

export var refRect : Rect2

func enableCamera():
	$Camera2D.current=true

func disableCamera():
	$Camera2D.current=false

func loadCameraLimits(refRect:ReferenceRect):
	
	var position=refRect.rect_global_position
	var rect=refRect.rect_size + position
	
	limitLeft=position.x
	limitTop=position.y
	limitRight=rect.x
	limitBottom=rect.y
	
	$Camera2D.limit_left=limitLeft
	$Camera2D.limit_top=limitTop
	$Camera2D.limit_right=limitRight
	$Camera2D.limit_bottom=limitBottom
	

func resetZoom():
	$Camera2D.zoom=Vector2(1,1)

func zoomDown():
	var zoom=0.7
	$Camera2D.zoom=Vector2(zoom,zoom)
	
func zoomUp():
	var zoom=2
	$Camera2D.zoom=Vector2(zoom,zoom)
	
func _ready():
	add_to_group("Player")
	#loadCameraLimits()
	resetZoom()

func _process(delta):
	
	pocessInput()
	
	var velocity = Vector2()  # The player's movement vector.
	
	if left:
		velocity.x -= 1
	elif right:
		velocity.x += 1
	elif up:
		velocity.y -= 1	
	elif down:
		velocity.y += 1
	
	var velocityMin=velocity	
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	var expectPosition=global_position+velocityMin
	

	if expectPosition.x < limitRight && expectPosition.x > limitLeft && expectPosition.y > limitTop && expectPosition.y < limitBottom: 	
		move_and_slide(velocity)
	
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
		
	if Input.is_action_just_pressed("ui_accept"):
		emit_signal("pressAccept")
	
	if Input.is_action_just_pressed("ui_cancel"):
		emit_signal("pressMenu")
		print("press menuA")
	
	
	if Input.is_action_pressed("ui_accept"):
		buttonPressed=true	
		useTouch=false
		

		
		
func processAnimation():
	var currentAnimation='walk-right'
	
	
	if buttonPressed && GlobalPlayer.getEquipment()==GlobalItems.ID.SPADE:
		currentAnimation='digging'
	elif buttonPressed && GlobalPlayer.getEquipment()==GlobalItems.ID.WOOD_SWORD:
		currentAnimation='attack1'
	elif startClimbing:
		currentAnimation='climbing'
	elif up :
		currentAnimation='walk-up'
		$AnimatedSprite.flip_h=true
	elif down :
		currentAnimation='walk-down'
		$AnimatedSprite.flip_h=false
	elif left:
		$AnimatedSprite.flip_h=true

	elif right:
		$AnimatedSprite.flip_h=false
	else:
		currentAnimation='idle'

	playAnimation(currentAnimation)


func playAnimation(anim):
	$AnimatedSprite/AnimationPlayer.play(anim)
	$AnimatedSprite/AnimationPlayer.play()

func stop():
	left=false
	right=false
	up=false
	down=false

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


func _on_gordonhome_playerStartClimbing():
	startClimbing=true
	emit_signal("startClimbing")

func _on_gordonhome_playerOnScale():
	onScale=true

func _on_gordonhome_playerLeaveScale():
	onScale=false

func _on_gordonhome_playerEndClimbing():
	if !onScale:
		startClimbing=false
		emit_signal("endClimbing")


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
		emit_signal("damagedBy",body)
		animDamage()
		

func animDamage():
	$redModulate.visible=true
	$timerModulate.start()


func _on_timerModulate_timeout():
	$redModulate.visible=false
