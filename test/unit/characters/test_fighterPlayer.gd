extends GutTest

# animations de combat de Gordon (epee en bois, epee en fer forge, mains nues)

const SpiderFight=preload("res://screens/macro-map/spiderFight.gd")
const FighterPlayer=preload("res://common/fighters/player.gd")

const IRON_ANIMATIONS=["attack_iron-sword_simple", "attack_iron-sword_legend"]
const WOOD_ANIMATIONS=["attack_wood-sword_simple", "attack_wood-sword_advanced"]
const PUNCH_ANIMATIONS=["attack_punch"]
const ATTACK_ANIMATIONS=IRON_ANIMATIONS+WOOD_ANIMATIONS+PUNCH_ANIMATIONS
# garde et degats, avec leur variante pour l'epee en fer et a mains nues
const OTHER_ANIMATIONS=["idle", "idle-iron", "damage", "damage-iron", "idle-bare", "damage-bare"]

var frames:SpriteFrames

func before_all():
	var scene=load("res://common/fighters/player.tscn").instantiate()
	frames=scene.get_node("AnimatedSprite2D").sprite_frames
	scene.free()

# debut de l'image index_, en fraction de la duree de l'animation
func _frameStart(animation_, index_):
	var total=0.0
	var start=0.0
	for i in frames.get_frame_count(animation_):
		if i==index_:
			start=total
		total+=frames.get_frame_duration(animation_, i)
	return start/total

func test_animationsExistAndLoop():
	for animation in ATTACK_ANIMATIONS+OTHER_ANIMATIONS:
		assert_true(frames.has_animation(animation), animation)
		# la fin est detectee par animation_looped
		assert_true(frames.get_animation_loop(animation), animation)

func test_framesAre64x64():
	for animation in ATTACK_ANIMATIONS+OTHER_ANIMATIONS:
		for i in frames.get_frame_count(animation):
			assert_eq(frames.get_frame_texture(animation, i).get_size(), Vector2(64, 64), "%s %d" % [animation, i])

func test_signalFallsOnFirstImpact():
	# le "!" s'ouvre pendant l'image du premier coup de lame
	for animation in ATTACK_ANIMATIONS:
		var impact=FighterPlayer.IMPACT_FRAMES[animation][0]
		assert_lte(_frameStart(animation, impact), SpiderFight.SIGNAL_AT, animation)
		assert_gt(_frameStart(animation, impact+1), SpiderFight.SIGNAL_AT, animation)

func test_impactFramesExist():
	for animation in ATTACK_ANIMATIONS:
		for impact in FighterPlayer.IMPACT_FRAMES[animation]:
			assert_lt(impact, frames.get_frame_count(animation), animation)

func test_ironVariantsMatchWoodTiming():
	# la garde et les degats durent autant quelle que soit l'epee
	for animation in ["idle", "damage"]:
		assert_eq(frames.get_frame_count(animation+"-iron"), frames.get_frame_count(animation), animation)
		for i in frames.get_frame_count(animation):
			assert_eq(frames.get_frame_duration(animation+"-iron", i), frames.get_frame_duration(animation, i), "%s %d" % [animation, i])

func test_bareVariantsMatchWoodTiming():
	# a mains nues, la garde et les degats durent autant qu'avec une epee
	for animation in ["idle", "damage"]:
		assert_eq(frames.get_frame_count(animation+"-bare"), frames.get_frame_count(animation), animation)
		for i in frames.get_frame_count(animation):
			assert_eq(frames.get_frame_duration(animation+"-bare", i), frames.get_frame_duration(animation, i), "%s %d" % [animation, i])

func test_punchStartsAndEndsOnBareGuard():
	# premiere et derniere images du coup de poing = garde a mains nues
	var guard=frames.get_frame_texture("idle-bare", 0).get_image()
	var last=frames.get_frame_count("attack_punch")-1
	assert_eq(frames.get_frame_texture("attack_punch", 0).get_image().get_data(), guard.get_data())
	assert_eq(frames.get_frame_texture("attack_punch", last).get_image().get_data(), guard.get_data())

# etat du joueur garde le temps d'un test (inventaire et objet en main)
var savedState={}
var savedPosition

# GlobalPlayer.reset() remet tout a zero : on garde l'etat complet pour
# ne rien laisser fuir vers les tests suivants
func _saveState():
	savedState={}
	for field in GlobalPlayer.simpleFieldToSaveList:
		var value=GlobalPlayer.get(field)
		savedState[field]=value.duplicate() if value is Array else value
	savedPosition=GlobalPlayer.position

func _restoreState():
	for field in savedState:
		GlobalPlayer.set(field, savedState[field])
	GlobalPlayer.position=savedPosition

func _fighter():
	var fighter=load("res://common/fighters/player.tscn").instantiate()
	add_child_autofree(fighter)
	return fighter

func test_bareHandedUsesBareAnimations():
	_saveState()
	GlobalPlayer.reset()
	var fighter=_fighter()
	assert_true(fighter.isBareHanded())
	assert_eq(String(fighter.getSprite().animation), "idle-bare")
	fighter.playDamage()
	assert_eq(String(fighter.getSprite().animation), "damage-bare")
	# une attaque sans animation dediee donne un coup de poing, pas l'epee en bois
	fighter.playAttack("")
	assert_eq(String(fighter.getSprite().animation), "attack_punch")
	assert_eq(fighter.getFallbackAttackAnimation(), "attack_punch")
	_restoreState()

func test_woodSwordKeepsSwordGuard():
	_saveState()
	GlobalPlayer.reset()
	GlobalPlayer.addItem(GlobalItems.ID.WOOD_SWORD)
	var fighter=_fighter()
	assert_false(fighter.isBareHanded())
	assert_eq(String(fighter.getSprite().animation), "idle")
	assert_eq(fighter.getFallbackAttackAnimation(), FighterPlayer.FALLBACK_ATTACK_ANIMATION)
	_restoreState()

func test_ironSwordAloneKeepsIronGuard():
	# seule l'epee en fer, pelle en main : la garde reste celle du fer
	_saveState()
	GlobalPlayer.reset()
	GlobalPlayer.addItem(GlobalItems.ID.IRON_SWORD)
	GlobalPlayer.addItem(GlobalItems.ID.SPADE)
	GlobalPlayer.setEquipment(GlobalItems.ID.SPADE)
	var fighter=_fighter()
	assert_true(fighter.hasIronSword())
	assert_eq(String(fighter.getSprite().animation), "idle-iron")
	_restoreState()
