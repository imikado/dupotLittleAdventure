extends Node2D

# Abeilles qui butinent autour du rucher : chacune decrit une boucle
# irreguliere (courbe de Lissajous) autour du noeud, ailes en 2 images

const FRAME_TIME=0.06

@export var count:=7
@export var radius:=Vector2(70, 34)

var bees=[]

func _ready():
	var texture=preload("res://common/effects/bee.png")
	for i in count:
		var sprite=Sprite2D.new()
		var atlas=AtlasTexture.new()
		atlas.atlas=texture
		sprite.texture=atlas
		add_child(sprite)
		bees.append({"sprite":sprite, "atlas":atlas, "clock":randf() * 20.0, "speed":randf_range(0.5, 0.9), "ratio":randf_range(1.3, 2.4), "phase":randf() * TAU, "scale":randf_range(0.4, 1.0)})

func _process(delta):
	for bee in bees:
		bee.clock+=delta
		var t=bee.clock * bee.speed
		var offset=Vector2(sin(t + bee.phase), sin(t * bee.ratio)) * radius * bee.scale
		var previous=bee.sprite.position
		bee.sprite.position=offset.round()
		# l'abeille regarde dans le sens de son vol
		if bee.sprite.position.x != previous.x:
			bee.sprite.flip_h=bee.sprite.position.x < previous.x
		var frame=int(bee.clock / FRAME_TIME) % 2
		bee.atlas.region=Rect2(frame * 5, 0, 5, 4)
