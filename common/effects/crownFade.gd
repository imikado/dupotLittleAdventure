extends Node

# Transmet la position de Gordon au materiau des couronnes d'arbres
# (common/shaders/crownFade.tres) pour les estomper quand il passe derriere

const MATERIAL=preload("res://common/shaders/crownFade.tres")

func _process(_delta):
	var player=get_tree().get_first_node_in_group("Player")
	if player:
		MATERIAL.set_shader_parameter("playerPos", player.global_position)
