extends Node2D

# Papillons d'ambiance : chacun vole vers un point au hasard de la zone de
# jeu en zigzaguant, se pose parfois (ailes fermees), puis repart

const FRAME_TIME=0.12
const SPEED=14.0
const COLORS=3

@export var area:NodePath
@export var count:=6

var butterflies=[]
var rect:Rect2

func _ready():
	var ref:ReferenceRect=get_node_or_null(area)
	if ref==null:
		return
	rect=Rect2(ref.global_position, ref.size)
	var texture=preload("res://common/effects/butterfly.png")
	for i in count:
		var sprite=Sprite2D.new()
		var atlas=AtlasTexture.new()
		atlas.atlas=texture
		sprite.texture=atlas
		add_child(sprite)
		var butterfly={"sprite":sprite, "atlas":atlas, "color":i % COLORS, "pos":randomPoint(), "target":randomPoint(), "rest":0.0, "clock":randf() * 10.0}
		butterflies.append(butterfly)
		setFrame(butterfly, 0)

func randomPoint():
	return rect.position + Vector2(randf() * rect.size.x, randf() * rect.size.y)

func setFrame(butterfly_, frame_):
	butterfly_.atlas.region=Rect2(frame_ * 7, butterfly_.color * 5, 7, 4)

func _process(delta):
	for butterfly in butterflies:
		butterfly.clock+=delta
		if butterfly.rest > 0.0:
			# pose : ailes fermees, battement lent de temps en temps
			butterfly.rest-=delta
			setFrame(butterfly, 1 if fmod(butterfly.clock, 1.4) < 1.2 else 0)
		else:
			var toTarget=butterfly.target - butterfly.pos
			if toTarget.length() < 4.0:
				butterfly.target=randomPoint()
				if randf() < 0.4:
					butterfly.rest=randf_range(1.5, 4.0)
			else:
				var direction=toTarget.normalized()
				# zigzag perpendiculaire a la direction de vol
				var side=Vector2(-direction.y, direction.x) * sin(butterfly.clock * 5.0) * 0.9
				butterfly.pos+=(direction + side) * SPEED * delta
			setFrame(butterfly, int(butterfly.clock / FRAME_TIME) % 2)
		# petit sautillement vertical du vol
		var bob=0.0 if butterfly.rest > 0.0 else round(sin(butterfly.clock * 9.0) * 1.0)
		butterfly.sprite.global_position=(butterfly.pos + Vector2(0, bob)).round()
