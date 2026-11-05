extends Node2D

signal attackFinished
signal damageFinished
signal dieFinished
# la lame touche l'adversaire (index_ : numero du coup dans l'animation)
signal attackImpact(animation_, index_)

var currentAnim=TYPE_ANIM.IDLE

enum TYPE_ANIM {ATTACK,DAMAGE,IDLE,DIE}

# point au-dessus de la tete (pour les degats affiches)
const HEAD_OFFSET=Vector2(0, -4)

const FALLBACK_ATTACK_ANIMATION="attack_wood-sword_advanced"
# coup de poing, quand Gordon n'a aucune arme
const PUNCH_ANIMATION="attack_punch"

# images d'impact des attaques qui en ont (effets synchronises dans le combat)
const IMPACT_FRAMES={
	"attack_wood-sword_simple":[4],
	"attack_wood-sword_advanced":[4, 6],
	"attack_iron-sword_simple":[4],
	"attack_iron-sword_legend":[5, 7],
	"attack_punch":[4],
}

# variantes de la garde et des degats quand l'epee en fer est en main
const IRON_SUFFIX="-iron"
# variantes de la garde et des degats a mains nues (aucune arme)
const BARE_SUFFIX="-bare"

func _ready():
	$AnimatedSprite2D.frame_changed.connect(_on_AnimatedSprite_frame_changed)
	playIdle()

# vrai si Gordon se bat avec l'epee en fer forge (ses attaques partent d'une
# autre garde) : elle est en main, ou c'est sa seule epee et il tient autre
# chose (la pelle)
func hasIronSword():
	var equipment=GlobalPlayer.getEquipment()
	if equipment!=null and GlobalItems.isWeapon(equipment):
		return int(equipment)==GlobalItems.ID.IRON_SWORD
	var items=GlobalPlayer.getItemsList()
	return items.has(GlobalItems.ID.IRON_SWORD) and !items.has(GlobalItems.ID.WOOD_SWORD)

# vrai si Gordon n'a aucune arme : il se bat a mains nues
func isBareHanded():
	return GlobalPlayer.getWeaponAttackList().is_empty()

# attaque jouee quand celle demandee n'a pas d'animation dediee
func getFallbackAttackAnimation():
	if isBareHanded():
		return PUNCH_ANIMATION
	return FALLBACK_ATTACK_ANIMATION

# animation adaptee a l'arme tenue (idle -> idle-iron, idle-bare...)
func _weaponAnimation(animation_):
	if isBareHanded() and $AnimatedSprite2D.sprite_frames.has_animation(animation_+BARE_SUFFIX):
		return animation_+BARE_SUFFIX
	if hasIronSword() and $AnimatedSprite2D.sprite_frames.has_animation(animation_+IRON_SUFFIX):
		return animation_+IRON_SUFFIX
	return animation_

func playAttack(animation_):
	# certaines attaques n'ont pas (encore) d'animation dediee
	if !$AnimatedSprite2D.sprite_frames.has_animation(animation_):
		animation_=getFallbackAttackAnimation()
	$AnimatedSprite2D.play(animation_)
	currentAnim=TYPE_ANIM.ATTACK

func playDamage():
	$AnimatedSprite2D.play(_weaponAnimation("damage"))
	currentAnim=TYPE_ANIM.DAMAGE

func playIdle():
	$AnimatedSprite2D.play(_weaponAnimation("idle"))
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

func _on_AnimatedSprite_frame_changed():
	if currentAnim!=TYPE_ANIM.ATTACK:
		return
	var animation=$AnimatedSprite2D.animation
	var impacts=IMPACT_FRAMES.get(animation, [])
	var index=impacts.find($AnimatedSprite2D.frame)
	if index>=0:
		emit_signal("attackImpact", animation, index)

func getHeadPosition():
	return position+HEAD_OFFSET

func getSprite():
	return $AnimatedSprite2D

# duree d'une animation (pour caler le signal "!" sur le coup porte)
func getAnimationDuration(animation_):
	var frames=$AnimatedSprite2D.sprite_frames
	if !frames.has_animation(animation_):
		return 0.0
	# chaque image peut avoir sa propre duree relative (anticipation, impact...)
	var total=0.0
	for i in frames.get_frame_count(animation_):
		total+=frames.get_frame_duration(animation_, i)
	return total/frames.get_animation_speed(animation_)
