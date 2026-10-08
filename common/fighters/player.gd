extends Node2D

signal attackFinished
signal damageFinished
signal dieFinished

var currentAnim=TYPE_ANIM.IDLE

enum TYPE_ANIM {ATTACK,DAMAGE,IDLE,DIE}

# point au-dessus de la tete (pour les degats affiches)
const HEAD_OFFSET=Vector2(0, -4)

const FALLBACK_ATTACK_ANIMATION="attack_wood-sword_advanced"

func playAttack(animation_):
	# certaines attaques n'ont pas (encore) d'animation dediee
	if !$AnimatedSprite2D.sprite_frames.has_animation(animation_):
		animation_=FALLBACK_ATTACK_ANIMATION
	$AnimatedSprite2D.play(animation_)
	currentAnim=TYPE_ANIM.ATTACK

func playDamage():
	$AnimatedSprite2D.play("damage")
	currentAnim=TYPE_ANIM.DAMAGE

func playIdle():
	$AnimatedSprite2D.play("idle")
	currentAnim=TYPE_ANIM.IDLE

func playDie():
	# pas d'animation "die" pour le joueur : on signale directement la fin
	if !$AnimatedSprite2D.sprite_frames.has_animation("die"):
		currentAnim=TYPE_ANIM.DIE
		stop()
		emit_signal("dieFinished")
		return
	$AnimatedSprite2D.play("die")
	currentAnim=TYPE_ANIM.DIE

func stop():
	$AnimatedSprite2D.stop()

func _on_AnimatedSprite_animation_finished():
	stop()
	# retour en garde avant de prevenir : le combat peut enchainer une autre animation
	if currentAnim==TYPE_ANIM.ATTACK:
		playIdle()
		emit_signal("attackFinished")
	elif currentAnim==TYPE_ANIM.DAMAGE:
		playIdle()
		emit_signal("damageFinished")
	elif currentAnim==TYPE_ANIM.DIE:
		emit_signal("dieFinished")
	elif currentAnim==TYPE_ANIM.IDLE:
		playIdle()

func getHeadPosition():
	return position+HEAD_OFFSET
