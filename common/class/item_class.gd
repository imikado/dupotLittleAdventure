extends Resource

class_name item_class 

enum TYPE {WEAPON, MAGICPOTION,MAP,TOOL,THING }

var simpleFieldToSaveList=["name","description","image","type"]

var name
var description
var image
var type
var actionList

func _init(name_,description_,image_,type_,actionList_=[]):
	self.name=name_
	self.description=description_
	self.image=image_
	self.type=type_
	self.actionList=actionList_

# texte dans la langue du jeu (dictionnaire FR/EN, ou texte deja traduit)
func _translate(text_):
	if text_ is Dictionary:
		return text_[GlobalGame.getLang()]
	return text_

func getName():
	return _translate(name)

func getDescription():
	return _translate(description)

func getTexture():

	var path="res://"+image
	
	return load(path)
	

