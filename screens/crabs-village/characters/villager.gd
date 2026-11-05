extends StaticBody2D

# Crabe d'ambiance du village : meme animation que le crabe d'accueil, avec
# sa propre planche (couleur) et un depart decale pour que les crabes ne
# respirent pas tous en meme temps

@export var sheet:Texture2D

func _ready():
	var sprite=$AnimatedSprite2D
	if sheet!=null:
		var source=sprite.sprite_frames
		var frames=SpriteFrames.new()
		frames.set_animation_speed("default", source.get_animation_speed("default"))
		frames.set_animation_loop("default", true)
		for i in source.get_frame_count("default"):
			var atlas=AtlasTexture.new()
			atlas.atlas=sheet
			atlas.region=source.get_frame_texture("default", i).region
			frames.add_frame("default", atlas, source.get_frame_duration("default", i))
		sprite.sprite_frames=frames
	sprite.play("default")
	sprite.frame=randi() % sprite.sprite_frames.get_frame_count("default")
