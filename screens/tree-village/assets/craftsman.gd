extends Node2D

signal talk

var talkingEnabled=true
var hasStillTalked=false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("default")
	talkingEnabled=true
	pass # Replace with function body.

func repair():
	$AnimatedSprite2D.play("repairing")
	talkingEnabled=false
	
func idle():
	$AnimatedSprite2D.play("default")
	if !hasStillTalked:
		talkingEnabled=true

func _on_talk_playerOpenedDoor():
	if talkingEnabled:
		emit_signal("talk")
		hasStillTalked=true
