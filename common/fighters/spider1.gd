extends Node2D

signal attackFinished
signal damageFinished
signal dieFinished

var currentAnim=TYPE_ANIM.IDLE

enum TYPE_ANIM {ATTACK,DAMAGE,IDLE,DIE}

# point au-dessus de la tete (pour les degats affiches)
const HEAD_OFFSET=Vector2(34, 28)

func playAttack(animation_):
	$AnimatedSprite2D.play(animation_)
	currentAnim=TYPE_ANIM.ATTACK

func playDamage():
	$AnimatedSprite2D.play("damage")
	currentAnim=TYPE_ANIM.DAMAGE

func playIdle():
	$AnimatedSprite2D.play("idle")
	currentAnim=TYPE_ANIM.IDLE

func playDie():
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

func getSprite():
	return $AnimatedSprite2D

# duree d'une animation (pour caler le signal "!" sur le coup porte)
func getAnimationDuration(animation_):
	var frames=$AnimatedSprite2D.sprite_frames
	if !frames.has_animation(animation_):
		return 0.0
	# chaque image peut avoir sa propre duree relative (elan, crachat...)
	var total=0.0
	for i in frames.get_frame_count(animation_):
		total+=frames.get_frame_duration(animation_, i)
	return total/frames.get_animation_speed(animation_)
