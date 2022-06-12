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

func getTexture():

	var path="res://"+image
	
	return load(path)
	

