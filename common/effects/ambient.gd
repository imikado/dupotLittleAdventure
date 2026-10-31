extends CPUParticles2D

# Particules d'ambiance (pollen, grains de sable...) semees sur toute la zone
# de jeu : on se cale sur le ReferenceRect qui borne deja la camera

@export var area:NodePath

func _ready():
	var rect:ReferenceRect=get_node_or_null(area)
	if rect==null:
		return
	var extents=rect.size/2
	global_position=rect.global_position+extents
	emission_rect_extents=extents
	# la densite suit la taille de la zone (environ une particule pour 2500 px2)
	amount=clamp(int(rect.size.x*rect.size.y/2500), 20, 300)
	restart()
