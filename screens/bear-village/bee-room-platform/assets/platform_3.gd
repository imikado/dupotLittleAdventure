extends KinematicBody2D

export(bool) var moving=false

export(Vector2) var start=Vector2.ZERO
export(Vector2) var end=Vector2.ZERO

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
		
		move_and_slide(relativeDirection*delta*speed)

		if relativeDirection.length() < 1:
			if target==start:
				target=end
			else:
				target=start



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
