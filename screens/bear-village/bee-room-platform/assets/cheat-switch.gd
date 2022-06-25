extends Area2D

signal enableCheatCode

onready var switchOff=get_node("swich-off")
onready var switchOn=get_node("swich-on")

var enabled=false

# Called when the node enters the scene tree for the first time.
func _ready():
	
	disable()

func reset():
	switchOff.visible=false
	switchOn.visible=false

func enable():
	reset()
	switchOn.visible=true
	enabled=true

func disable():
	reset()
	switchOff.visible=true
	enabled=false


func _on_switcharea_body_entered(body):
	if body.is_in_group("Player"):
		enable()
		
		emit_signal("enableCheatCode")
	pass # Replace with function body.
