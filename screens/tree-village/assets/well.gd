extends Node2D


signal talk
signal repaired


enum {BROKEN,IS_REPAIRING,REPAIRED}
var state=BROKEN

var stateAnimation=[]

func setRepaired():
	setState(REPAIRED)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	stateAnimation={
		BROKEN:"idle",
		IS_REPAIRING:"is-repairing",
		REPAIRED:"repaired"
	}
	setState(BROKEN)



# pendant la reparation, l'artisan saute sur la margelle et le toit du puits :
# il reste dessine devant le puits (sinon le tri en profondeur le cache)
func repair():
	setState(IS_REPAIRING)
	$craftsman.z_index=1
	$craftsman.repair()

func setState(state_):
	state=state_
	#$AnimatedSprite.play(stateAnimation[state_])
	$AnimatedSprite2D/AnimationPlayer.play(stateAnimation[state_])


func _on_AnimatedSprite_animation_finished():
	if state==IS_REPAIRING:
		setState(REPAIRED)
		$craftsman.visible=false
		$craftsman.z_index=0
		$craftsman.idle()
		
	


func _on_craftsman_talk():
	emit_signal("talk")


func _on_AnimationPlayer_animation_finished(anim_name):
	if state==IS_REPAIRING:
		setState(REPAIRED)
		$craftsman.z_index=0
		$craftsman.idle()
				
		$Timer.start()


func _on_Timer_timeout():
	emit_signal("repaired")
	pass # Replace with function body.
