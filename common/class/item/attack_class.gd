extends Resource

class_name attack_class

var name
var animation
var damage
var xpMin

func _init(name_,animation_,damage_,xpMin_):
	self.name=name_
	self.animation=animation_
	self.damage=damage_
	self.xpMin=xpMin_

# nom dans la langue du jeu (dictionnaire FR/EN, ou texte deja traduit)
func getName():
	if name is Dictionary:
		return name[GlobalGame.getLang()]
	return name
