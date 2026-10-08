extends CharacterBody2D

@export var moving: bool=false

@export var start: Vector2=Vector2.ZERO
@export var end: Vector2=Vector2.ZERO

var speed=100

var target=Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	if start==Vector2.ZERO:
		start=position

		if end.x==0:
			end.x=start.x

		if end.y==0:
			end.y=start.y
				

	target=end


func _physics_process(delta):
	if moving:
		print("moving to ")
		var relativeDirection=target-position
		
		set_velocity(relativeDirection*delta*speed)
		move_and_slide()

		if relativeDirection.length() < 1:
			if target==start:
				target=end
			else:
				target=start



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
