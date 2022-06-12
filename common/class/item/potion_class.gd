extends Resource

class_name potion_class

enum ACTION {INCREASE_LIFE,INCREASE_MAGIC}

var action
var value

func _init(action_,value_):
	action=action_
	value=value_
