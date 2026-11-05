extends AnimatedSprite2D

# Abeille de decor : tourne autour de son point de depart en dessinant des huit

@export var radius=Vector2(14,6)
@export var speed=1.0

var anchor=Vector2.ZERO
var time=0.0

func _ready():
	anchor=position
	# chaque abeille demarre a un moment different de sa boucle
	time=randf()*TAU
	frame=randi()%2
	play("fly")

func _process(delta_):
	time+=delta_*speed
	var newPosition=anchor+Vector2(sin(time)*radius.x, sin(time*2.0)*radius.y)
	if newPosition.x!=position.x:
		flip_h=newPosition.x>position.x
	position=newPosition
