extends KinematicBody2D

var speed = 10

var player

var directionBack

var shouldGoBack=false


func setPlayer(player_):
	player=player_

func getPlayer():
	return player

func _ready():
	add_to_group("Enemy")
	
	$AnimatedSprite.play()


func _process(delta):
	if shouldGoBack:
		move_and_collide(directionBack)
		shouldGoBack=false
		return
		
	
	var player_relative_position = getPlayer().getPlayerPosition() - position
	
	var direction = Vector2.ZERO
	
	if player_relative_position.length() <= 1:
		direction = Vector2.ZERO
	elif player_relative_position.length() <= 110:
		direction = player_relative_position.normalized()
	
	move_and_collide(direction*delta*speed)
	
	if player_relative_position.length() > 10:
		directionBack=-1*direction*speed


func goBack():
	shouldGoBack=true

