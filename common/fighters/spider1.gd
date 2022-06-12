extends Node2D

signal attackFinished
signal damageFinished
signal dieFinished

var currentAnim=TYPE_ANIM.IDLE

enum TYPE_ANIM {ATTACK,DAMAGE,IDLE,DIE}

func playAttack(animation_):
	$AnimatedSprite.play(animation_)
	currentAnim=TYPE_ANIM.ATTACK

func playDamage():
	$AnimatedSprite.play("damage")
	currentAnim=TYPE_ANIM.DAMAGE

func playIdle():
	$AnimatedSprite.play("idle")
	currentAnim=TYPE_ANIM.IDLE

func playDie():
	$AnimatedSprite.play("die")
	currentAnim=TYPE_ANIM.DIE

func stop():
	$AnimatedSprite.stop()

func _on_AnimatedSprite_animation_finished():
	stop()
	if currentAnim==TYPE_ANIM.ATTACK:
		emit_signal("attackFinished")
	elif currentAnim==TYPE_ANIM.DAMAGE:
		emit_signal("damageFinished")
	elif currentAnim==TYPE_ANIM.DIE:
		emit_signal("dieFinished")
	elif currentAnim==TYPE_ANIM.IDLE:
		playIdle()
