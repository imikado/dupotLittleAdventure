extends CharacterBody2D

signal startClimbing
signal endClimbing

signal hit(enemy_)
signal damagedBy(enemy_)

signal pressAccept
signal releaseAccept
signal pressMenu

signal useKeyboard

var speed=100

var left=false
var right=false
var up=false
var down=false
var buttonPressed=false

var useTouch=true

var climbingStarted=false
var onScale=false
var isClimbing=false

var limitLeft=0
var limitRight=0
var limitTop=0
var limitBottom=0

@export var refRect : Rect2

var navigationEnabled=true

# zone morte et rapport d'axes du joystick tactile (8 directions)
const JOYSTICK_DEAD_ZONE=10
const JOYSTICK_DIAGONAL_RATIO=0.4

# invincibilite apres un coup (en ms) : le personnage clignote
const INVINCIBILITY_DURATION=1000
var invincibleUntil=0
var wasInvincible=false

func enableNavigation():
	navigationEnabled=true

func disableNavigation():
	navigationEnabled=false

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
	
	processInvincibility()
	
	if !navigationEnabled:
		return
	
	pocessInput()
	
	# deplacement en 8 directions, vitesse identique en diagonale
	var motion = Vector2(int(right)-int(left), int(down)-int(up))
	
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
		
	if Input.is_action_just_pressed("ui_accept"):
		emit_signal("pressAccept")
	
	if Input.is_action_just_pressed("ui_cancel"):
		emit_signal("pressMenu")
		print("press menuA")
	
	
	if Input.is_action_just_pressed("ui_accept"):
		buttonPressed=true	
		useTouch=false
	
	if Input.is_action_just_released("ui_accept"):
		emit_signal("releaseAccept")
		buttonPressed=false
		useTouch=false

	if !useTouch:
		emit_signal("useKeyboard")
		GlobalPlayer.disableTouch()
		
		
func processAnimation():
	var currentAnimation='walk-right'
	
	
	if buttonPressed && GlobalPlayer.getEquipment()==GlobalItems.ID.SPADE:
		currentAnimation='digging'
	elif buttonPressed && GlobalPlayer.getEquipment()==GlobalItems.ID.WOOD_SWORD:
		currentAnimation='attack1'
	elif climbingStarted:
		currentAnimation='climbing'
	elif left != right:
		# en diagonale, on garde l'animation de profil
		$AnimatedSprite2D.flip_h=left
	elif up :
		currentAnimation='walk-up'
		$AnimatedSprite2D.flip_h=true
	elif down :
		currentAnimation='walk-down'
		$AnimatedSprite2D.flip_h=false
	else:
		currentAnimation='idle'

	playAnimation(currentAnimation)


func playAnimation(anim):
	$AnimatedSprite2D/AnimationPlayer.play(anim)
	$AnimatedSprite2D/AnimationPlayer.play()

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
	
	var x=joystickVector_.x
	var y=joystickVector_.y
	# un axe compte s'il depasse la zone morte et n'est pas negligeable face a l'autre
	var useX=abs(x) > abs(y)*JOYSTICK_DIAGONAL_RATIO
	var useY=abs(y) > abs(x)*JOYSTICK_DIAGONAL_RATIO
	right=useX and x > JOYSTICK_DEAD_ZONE
	left=useX and x < -JOYSTICK_DEAD_ZONE
	down=useY and y > JOYSTICK_DEAD_ZONE
	up=useY and y < -JOYSTICK_DEAD_ZONE


func _on_gordonhome_playerStartClimbing():
	climbingStarted=true
	emit_signal("startClimbing")

func _on_gordonhome_playerOnScale():
	onScale=true

func _on_gordonhome_playerLeaveScale():
	onScale=false

func _on_gordonhome_playerEndClimbing():
	if !onScale:
		climbingStarted=false
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
		takeDamageFrom(body)

func isInvincible():
	return Time.get_ticks_msec() < invincibleUntil

func takeDamageFrom(enemy_):
	if isInvincible():
		return
	invincibleUntil=Time.get_ticks_msec()+INVINCIBILITY_DURATION
	emit_signal("damagedBy",enemy_)
	animDamage()

func processInvincibility():
	var invincible=isInvincible()
	$AnimatedSprite2D.visible=!invincible or (Time.get_ticks_msec()/80)%2==0
	if wasInvincible and !invincible:
		# un ennemi encore au contact a la fin de l'invincibilite touche a nouveau
		for body in $damage.get_overlapping_bodies():
			if body.is_in_group("Enemy"):
				takeDamageFrom(body)
				break
	wasInvincible=invincible

func animDamage():
	$redModulate.visible=true
	$timerModulate.start()


func _on_timerModulate_timeout():
	$redModulate.visible=false



