extends Node2D

const FightRules=preload("res://common/class/fight_rules.gd")
const WorldMap=preload("res://screens/macro-map.gd")
const DefaultTheme=preload("res://common/themes/default.tres")
const SPARK_TEXTURE=preload("res://screens/macro-map/images/spark.png")
const IMPACT_TEXTURE=preload("res://screens/macro-map/images/impact.png")

const SPIDER_MAX_LIFE=50
const SPIDER_DAMAGE=10
const VICTORY_XP=3
const VICTORY_GEMS_MIN=2
const VICTORY_GEMS_MAX=4
const MESSAGE_DELAY=0.8

const COLOR_DAMAGE=Color(1, 0.95, 0.85)
const COLOR_CRITICAL=Color(1, 0.82, 0.4)
const COLOR_HEAL=Color(0.45, 1, 0.55)
const COLOR_SIGNAL=Color(1, 0.86, 0.45)
const COLOR_OUTLINE=Color(0.13, 0.125, 0.2)

# elan des combattants vers l'adversaire
const LUNGE_DISTANCE=60
const LUNGE_DURATION=0.18
# entree en scene : chacun arrive de son cote
const ENTER_OFFSET=140
const ENTER_DURATION=0.45

# etincelles d'impact : point touche par rapport a la tete de chaque combattant
const SPIDER_IMPACT_OFFSET=Vector2(-16, 16)
const PLAYER_IMPACT_OFFSET=Vector2(4, 10)
const SPARK_COUNT=6
const SPARK_COUNT_STRONG=10

# signal "!" : il s'ouvre a ce pourcentage de l'animation d'attaque
const SIGNAL_AT=0.45
const SIGNAL_WINDOW=0.3

# attaque "Lame de legende" : chaque coup de lame secoue l'araignee
const LEGEND_ANIMATION="attack_iron-sword_legend"

const UP="UP"
const DOWN="DOWN"

enum PRESS {IDLE, WAITING, OPEN}

var lifeSpider=SPIDER_MAX_LIFE

var positionToGoUp
var positionToGoDown

var playerSavedLife=0

var rng=RandomNumberGenerator.new()

var pressState=PRESS.IDLE
var pressedEarly=false
var pressSucceeded=false

func _ready():
	rng.randomize()

	$player.attackImpact.connect(_on_player_attackImpact)

	playerSavedLife=GlobalPlayer.getLife()
	$lifePlayer.init(_trad(GlobalGame.TRAD_WORD_GORDON), GlobalPlayer.getLife(), GlobalPlayer.getMaxLife())
	$lifeSpider.init(_trad(GlobalGame.TRAD_FIGHT_SPIDER), lifeSpider, SPIDER_MAX_LIFE)

	# etapes de la carte de part et d'autre de la toile
	positionToGoUp=WorldMap.SPIDER_NORTH
	positionToGoDown=WorldMap.SPIDER_SOUTH

	$gamepad.showMessage(_trad(GlobalGame.TRAD_FIGHT_APPEAR))
	await _enterFighters()
	await _wait(MESSAGE_DELAY)
	$gamepad.showMessage(_trad(GlobalGame.TRAD_FIGHT_TIP))
	await _wait(MESSAGE_DELAY*2)
	_playerTurn()

func _playerTurn():
	$gamepad.showMessage(_trad(GlobalGame.TRAD_FIGHT_CHOOSE) % _trad(GlobalGame.TRAD_WORD_GORDON))
	$gamepad.showActions()

#--- actions du joueur

func _on_gamepad_attack(attack_):
	var roll=FightRules.rollDamage(attack_.damage, rng)
	$gamepad.showMessage(_trad(GlobalGame.TRAD_FIGHT_PLAYER_ATTACK) % [_trad(GlobalGame.TRAD_WORD_GORDON), attack_.getName()])

	await _lunge($player, LUNGE_DISTANCE)
	$player.playAttack(attack_.animation)
	var duration=$player.getAnimationDuration(attack_.animation)
	if duration==0.0:
		duration=$player.getAnimationDuration($player.getFallbackAttackAnimation())
	_watchPress($player, duration*SIGNAL_AT)
	await $player.attackFinished
	var perfect=pressSucceeded
	_closePress()

	var damage=roll.damage
	if perfect:
		damage=FightRules.applyPerfect(damage)
		_popText($player, _trad(GlobalGame.TRAD_FIGHT_PERFECT), COLOR_SIGNAL, false, -12)
		Sfx.play(Sfx.PERFECT)
	lifeSpider=max(0, lifeSpider-damage)
	$spider1.playDamage()
	Sfx.play(Sfx.CRITICAL if roll.critical or perfect else Sfx.HIT)
	_hitEffect($spider1, roll.critical or perfect)
	_popText($spider1, str(damage), COLOR_CRITICAL if roll.critical or perfect else COLOR_DAMAGE, roll.critical or perfect)
	$lifeSpider.updateValue(lifeSpider)
	if roll.critical:
		$gamepad.showMessage(_trad(GlobalGame.TRAD_FIGHT_CRITICAL))
	_lunge($player, -LUNGE_DISTANCE)
	await $spider1.damageFinished

	if lifeSpider <= 0:
		_victory()
	else:
		_enemyTurn()

# la lame touche : bruit de coup, et pour la Lame de legende eclair + secousses
func _on_player_attackImpact(animation_, index_):
	Sfx.play(Sfx.SWING)
	var impact=$spider1.getHeadPosition()+SPIDER_IMPACT_OFFSET
	if animation_!=LEGEND_ANIMATION:
		_impactSparks(impact, false)
		return
	_impactSparks(impact, true)
	if index_==0:
		_flashScreen()
		_hitEffect($spider1, true)
	else:
		_hitEffect($spider1, false)
		_shakeScreen()

func _on_gamepad_usePotion():
	var lifeBefore=GlobalPlayer.getLife()
	GlobalPlayer.useItem(GlobalItems.ID.HEALTH_POTION_10)
	var healed=GlobalPlayer.getLife()-lifeBefore
	$gamepad.showMessage(_trad(GlobalGame.TRAD_FIGHT_POTION_USED) % _trad(GlobalGame.TRAD_WORD_GORDON))
	Sfx.play(Sfx.HEAL)
	_healEffect($player)
	_popText($player, "+"+str(healed), COLOR_HEAL)
	$lifePlayer.updateValue(GlobalPlayer.getLife())
	await _wait(MESSAGE_DELAY)
	_enemyTurn()

func _on_gamepad_leave():
	if FightRules.rollFlee(rng):
		$gamepad.showMessage(_trad(GlobalGame.TRAD_FIGHT_FLEE_OK))
		# Gordon detale hors de l'ecran
		$player.getSprite().flip_h=true
		var tween=create_tween()
		tween.tween_property($player, "position:x", $player.position.x-ENTER_OFFSET, MESSAGE_DELAY*0.6).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		await _wait(MESSAGE_DELAY)
		_gotoMap(false)
	else:
		$gamepad.showMessage(_trad(GlobalGame.TRAD_FIGHT_FLEE_FAIL))
		Sfx.play(Sfx.MISS)
		await _wait(MESSAGE_DELAY)
		_enemyTurn()

#--- tour de l'araignee

func _enemyTurn():
	$gamepad.showMessage(_trad(GlobalGame.TRAD_FIGHT_ENEMY_ATTACK))
	await _lunge($spider1, -LUNGE_DISTANCE)
	$spider1.playAttack("attack-1")
	# Gordon peut parer en appuyant au signal
	_watchPress($player, $spider1.getAnimationDuration("attack-1")*SIGNAL_AT)
	await $spider1.attackFinished
	var parried=pressSucceeded
	_closePress()
	_lunge($spider1, LUNGE_DISTANCE)

	if !FightRules.rollEnemyHit(rng):
		Sfx.play(Sfx.MISS)
		_popText($player, _trad(GlobalGame.TRAD_FIGHT_MISS), COLOR_DAMAGE)
		$gamepad.showMessage(_trad(GlobalGame.TRAD_FIGHT_ENEMY_MISS))
		await _wait(MESSAGE_DELAY)
		_playerTurn()
		return

	var roll=FightRules.rollDamage(SPIDER_DAMAGE, rng, false)
	var damage=roll.damage
	if parried:
		damage=FightRules.applyParry(damage)
		_popText($player, _trad(GlobalGame.TRAD_FIGHT_PARRY), COLOR_SIGNAL, false, -12)
		Sfx.play(Sfx.PERFECT)
	GlobalPlayer.damage(damage)
	$player.playDamage()
	Sfx.play(Sfx.HIT)
	_hitEffect($player, false)
	_impactSparks($player.getHeadPosition()+PLAYER_IMPACT_OFFSET, false)
	_popText($player, str(damage), COLOR_DAMAGE)
	$lifePlayer.updateValue(GlobalPlayer.getLife())
	await $player.damageFinished

	if GlobalPlayer.getLife() <= 0:
		_defeat()
	else:
		_playerTurn()

#--- fin du combat

func _victory():
	$spider1.playDie()
	await $spider1.dieFinished
	# l'araignee clignote puis disparait
	var sprite=$spider1.getSprite()
	for i in 6:
		sprite.visible=!sprite.visible
		await _wait(0.06)
	$spider1.visible=false

	var gems=rng.randi_range(VICTORY_GEMS_MIN, VICTORY_GEMS_MAX)
	WorldMap.setSpiderRest(WorldMap.SPIDER_REST_CROSSINGS)
	GlobalPlayer.addXp(VICTORY_XP)
	GlobalPlayer.addGems(gems)
	$gamepad.showMessage(_trad(GlobalGame.TRAD_FIGHT_VICTORY) % [VICTORY_XP, gems])
	Sfx.play(Sfx.VICTORY)
	# petits sauts de joie
	var tween=create_tween()
	var groundY=$player.position.y
	for i in 2:
		tween.tween_property($player, "position:y", groundY-8, 0.14).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property($player, "position:y", groundY, 0.14).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	await _wait(MESSAGE_DELAY*2)
	_gotoMap(true)

func _defeat():
	$gamepad.showMessage(_trad(GlobalGame.TRAD_FIGHT_DEFEAT) % _trad(GlobalGame.TRAD_WORD_GORDON))
	var tween=$player.create_tween()
	tween.tween_property($player, "modulate:a", 0.0, MESSAGE_DELAY)
	await _wait(MESSAGE_DELAY*2)
	# defaite : comme dans la salle des BeVil, on recupere la vie d'avant le combat
	# et on recule sur la carte
	GlobalPlayer.setLife(playerSavedLife)
	_gotoMap(false)

# victoire : on passe de l'autre cote de la toile ; sinon on recule
func _gotoMap(crossed_):
	var goUp=(GlobalPlayer.getSide()==UP)!=crossed_
	GlobalPlayer.savePosition(positionToGoUp if goUp else positionToGoDown)
	SceneTransition.change_scene("res://screens/macro-map.tscn")

#--- action au bon moment

# le signal "!" s'affiche au-dessus de Gordon apres delay_ secondes
func _watchPress(fighter_:Node2D, delay_):
	pressState=PRESS.WAITING
	pressedEarly=false
	pressSucceeded=false
	await _wait(delay_)
	if pressState!=PRESS.WAITING:
		return
	pressState=PRESS.OPEN
	var signalLabel=_makeLabel("!", COLOR_SIGNAL, 24)
	signalLabel.name="signal"
	signalLabel.position=fighter_.getHeadPosition()-Vector2(signalLabel.size.x/2, signalLabel.size.y+10)
	signalLabel.pivot_offset=signalLabel.size/2
	signalLabel.scale=Vector2(0.5, 0.5)
	signalLabel.create_tween().tween_property(signalLabel, "scale", Vector2.ONE, 0.08)
	await _wait(SIGNAL_WINDOW)
	if is_instance_valid(signalLabel):
		signalLabel.queue_free()
	if pressState==PRESS.OPEN:
		pressState=PRESS.IDLE

func _closePress():
	pressState=PRESS.IDLE
	if has_node("signal"):
		get_node("signal").queue_free()

func _unhandled_input(event):
	if pressState==PRESS.IDLE:
		return
	var pressed=event.is_action_pressed("ui_accept") or (event is InputEventScreenTouch and event.pressed)
	if !pressed:
		return
	get_viewport().set_input_as_handled()
	# appuyer trop tot (ou marteler) ne marche pas
	if pressState==PRESS.WAITING:
		pressedEarly=true
	elif pressState==PRESS.OPEN and !pressedEarly and !pressSucceeded:
		pressSucceeded=true
		if has_node("signal"):
			get_node("signal").modulate=Color(3, 3, 3)

#--- effets

func _wait(seconds_):
	return get_tree().create_timer(seconds_).timeout

func _enterFighters():
	Sfx.play(Sfx.BATTLE)
	_flashScreen()
	var playerTarget=$player.position
	var spiderTarget=$spider1.position
	$player.position.x-=ENTER_OFFSET
	$spider1.position.x+=ENTER_OFFSET
	var tween=create_tween().set_parallel()
	tween.tween_property($player, "position", playerTarget, ENTER_DURATION).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property($spider1, "position", spiderTarget, ENTER_DURATION).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	await tween.finished

func _lunge(fighter_:Node2D, distance_):
	var tween=fighter_.create_tween()
	tween.tween_property(fighter_, "position:x", fighter_.position.x+distance_, LUNGE_DURATION).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	await tween.finished

# eclair blanc plein ecran (debut de combat)
func _flashScreen():
	var flash=ColorRect.new()
	flash.color=Color.WHITE
	flash.size=get_viewport_rect().size
	flash.z_index=20
	flash.mouse_filter=Control.MOUSE_FILTER_IGNORE
	add_child(flash)
	var tween=flash.create_tween()
	for alpha in [0.0, 0.8, 0.0, 0.5, 0.0]:
		tween.tween_property(flash, "color:a", alpha, 0.05)
	tween.tween_callback(flash.queue_free)

# eclair blanc + petite secousse du combattant touche
func _hitEffect(fighter_:Node2D, strong_):
	var origin=fighter_.position
	var amplitude=4 if strong_ else 2
	var sprite=fighter_.getSprite()
	var tween=fighter_.create_tween()
	sprite.modulate=Color(3, 3, 3)
	tween.tween_property(sprite, "modulate", Color.WHITE, 0.2)
	for i in 4:
		var side=1 if i%2==0 else -1
		tween.parallel().tween_property(fighter_, "position", origin+Vector2(amplitude*side, 0), 0.04).set_delay(i*0.04)
	tween.tween_property(fighter_, "position", origin, 0.04)
	if strong_:
		_shakeScreen()

# etoile d'impact au point touche, et etincelles projetees en etoile
func _impactSparks(position_:Vector2, strong_):
	var star=Sprite2D.new()
	star.texture=IMPACT_TEXTURE
	star.position=position_.round()
	star.z_index=9
	star.scale=Vector2(2, 2) if strong_ else Vector2.ONE
	add_child(star)
	var starTween=star.create_tween()
	starTween.tween_interval(0.08)
	starTween.tween_property(star, "modulate:a", 0.0, 0.1)
	starTween.tween_callback(star.queue_free)
	var count=SPARK_COUNT_STRONG if strong_ else SPARK_COUNT
	for i in count:
		var spark=Sprite2D.new()
		spark.texture=SPARK_TEXTURE
		spark.position=position_.round()
		spark.z_index=9
		add_child(spark)
		var angle=TAU*i/count+rng.randf_range(-0.3, 0.3)
		var distance=rng.randf_range(10, 24 if strong_ else 16)
		var target=(position_+Vector2.from_angle(angle)*distance).round()
		var sparkTween=spark.create_tween()
		sparkTween.tween_property(spark, "position", target, 0.25).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		sparkTween.parallel().tween_property(spark, "modulate:a", 0.0, 0.12).set_delay(0.15)
		sparkTween.tween_callback(spark.queue_free)

# halo vert et etincelles qui montent
func _healEffect(fighter_:Node2D):
	var sprite=fighter_.getSprite()
	var tween=sprite.create_tween()
	tween.tween_property(sprite, "modulate", Color(0.6, 1.6, 0.8), 0.15)
	tween.tween_property(sprite, "modulate", Color.WHITE, 0.35)
	for i in 5:
		var spark=_makeLabel("+", COLOR_HEAL, 8)
		spark.position=fighter_.getHeadPosition()+Vector2(rng.randi_range(-12, 8), rng.randi_range(4, 26))
		var sparkTween=spark.create_tween()
		sparkTween.tween_property(spark, "position:y", spark.position.y-16, 0.5).set_delay(i*0.07)
		sparkTween.parallel().tween_property(spark, "modulate:a", 0.0, 0.25).set_delay(0.3+i*0.07)
		sparkTween.tween_callback(spark.queue_free)

func _shakeScreen():
	var tween=create_tween()
	for i in 6:
		tween.tween_property(self, "position", Vector2(rng.randi_range(-3, 3), rng.randi_range(-2, 2)), 0.03)
	tween.tween_property(self, "position", Vector2.ZERO, 0.03)

func _makeLabel(text_, color_, size_):
	var label=Label.new()
	label.theme=DefaultTheme
	label.text=text_
	label.z_index=10
	label.add_theme_color_override("font_color", color_)
	label.add_theme_color_override("font_outline_color", COLOR_OUTLINE)
	label.add_theme_constant_override("outline_size", 4)
	label.add_theme_font_size_override("font_size", size_)
	add_child(label)
	label.reset_size()
	return label

# nombre (ou texte) qui jaillit au-dessus du combattant, rebondit puis s'efface
func _popText(fighter_:Node2D, text_, color_, big_=false, offsetY_=0):
	var label=_makeLabel(text_, color_, 24 if big_ else 16)
	label.position=fighter_.getHeadPosition()-Vector2(label.size.x/2, label.size.y-offsetY_)
	var restY=label.position.y-10
	var tween=label.create_tween()
	tween.tween_property(label, "position:y", restY-8, 0.15).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(label, "position:y", restY, 0.25).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	tween.tween_property(label, "modulate:a", 0.0, 0.25).set_delay(0.3)
	tween.tween_callback(label.queue_free)

func _trad(id_):
	return GlobalGame.getTraductionById(id_)
