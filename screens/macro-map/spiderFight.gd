extends Node2D

const FightRules=preload("res://common/class/fight_rules.gd")
const DefaultTheme=preload("res://common/themes/default.tres")

const HERO_NAME="Gordon"
const SPIDER_MAX_LIFE=50
const SPIDER_DAMAGE=10
const VICTORY_XP=3
const VICTORY_GEMS_MIN=2
const VICTORY_GEMS_MAX=4
const MESSAGE_DELAY=0.8

const COLOR_DAMAGE=Color(1, 0.95, 0.85)
const COLOR_CRITICAL=Color(1, 0.82, 0.4)
const COLOR_HEAL=Color(0.45, 1, 0.55)
const COLOR_OUTLINE=Color(0.13, 0.125, 0.2)

const UP="UP"
const DOWN="DOWN"

var lifeSpider=SPIDER_MAX_LIFE

var positionToGoUp
var positionToGoDown

var playerSavedLife=0

var rng=RandomNumberGenerator.new()

func _ready():
	rng.randomize()

	playerSavedLife=GlobalPlayer.getLife()
	$lifePlayer.init(HERO_NAME, GlobalPlayer.getLife(), GlobalPlayer.getMaxLife())
	$lifeSpider.init(_trad(GlobalGame.TRAD_FIGHT_SPIDER), lifeSpider, SPIDER_MAX_LIFE)

	positionToGoUp=Vector2( GlobalPlayer.getPosition().x,260)
	positionToGoDown=Vector2( GlobalPlayer.getPosition().x,420)

	$gamepad.showMessage(_trad(GlobalGame.TRAD_FIGHT_APPEAR))
	await _wait(MESSAGE_DELAY)
	_playerTurn()

func _playerTurn():
	$gamepad.showMessage(_trad(GlobalGame.TRAD_FIGHT_CHOOSE) % HERO_NAME)
	$gamepad.showActions()

#--- actions du joueur

func _on_gamepad_attack(attack_):
	var roll=FightRules.rollDamage(attack_.damage, rng)
	$gamepad.showMessage(_trad(GlobalGame.TRAD_FIGHT_PLAYER_ATTACK) % [HERO_NAME, attack_.name])
	$player.playAttack(attack_.animation)
	await $player.attackFinished

	lifeSpider=max(0, lifeSpider-roll.damage)
	$spider1.playDamage()
	_hitEffect($spider1, roll.critical)
	_popText($spider1, str(roll.damage), COLOR_CRITICAL if roll.critical else COLOR_DAMAGE, roll.critical)
	$lifeSpider.updateValue(lifeSpider)
	if roll.critical:
		$gamepad.showMessage(_trad(GlobalGame.TRAD_FIGHT_CRITICAL))
	await $spider1.damageFinished

	if lifeSpider <= 0:
		_victory()
	else:
		_enemyTurn()

func _on_gamepad_usePotion():
	var lifeBefore=GlobalPlayer.getLife()
	GlobalPlayer.useItem(GlobalItems.ID.HEALTH_POTION_10)
	var healed=GlobalPlayer.getLife()-lifeBefore
	$gamepad.showMessage(_trad(GlobalGame.TRAD_FIGHT_POTION_USED) % HERO_NAME)
	_popText($player, "+"+str(healed), COLOR_HEAL)
	$lifePlayer.updateValue(GlobalPlayer.getLife())
	await _wait(MESSAGE_DELAY)
	_enemyTurn()

func _on_gamepad_leave():
	if FightRules.rollFlee(rng):
		$gamepad.showMessage(_trad(GlobalGame.TRAD_FIGHT_FLEE_OK))
		await _wait(MESSAGE_DELAY)
		_gotoMap(false)
	else:
		$gamepad.showMessage(_trad(GlobalGame.TRAD_FIGHT_FLEE_FAIL))
		await _wait(MESSAGE_DELAY)
		_enemyTurn()

#--- tour de l'araignee

func _enemyTurn():
	$gamepad.showMessage(_trad(GlobalGame.TRAD_FIGHT_ENEMY_ATTACK))
	$spider1.playAttack("attack-1")
	await $spider1.attackFinished

	if !FightRules.rollEnemyHit(rng):
		_popText($player, _trad(GlobalGame.TRAD_FIGHT_MISS), COLOR_DAMAGE)
		$gamepad.showMessage(_trad(GlobalGame.TRAD_FIGHT_ENEMY_MISS))
		await _wait(MESSAGE_DELAY)
		_playerTurn()
		return

	var roll=FightRules.rollDamage(SPIDER_DAMAGE, rng, false)
	GlobalPlayer.damage(roll.damage)
	$player.playDamage()
	_hitEffect($player, false)
	_popText($player, str(roll.damage), COLOR_DAMAGE)
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
	$spider1.visible=false

	var gems=rng.randi_range(VICTORY_GEMS_MIN, VICTORY_GEMS_MAX)
	GlobalPlayer.addXp(VICTORY_XP)
	GlobalPlayer.addGems(gems)
	$gamepad.showMessage(_trad(GlobalGame.TRAD_FIGHT_VICTORY) % [VICTORY_XP, gems])
	await _wait(MESSAGE_DELAY*2)
	_gotoMap(true)

func _defeat():
	$gamepad.showMessage(_trad(GlobalGame.TRAD_FIGHT_DEFEAT) % HERO_NAME)
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

#--- effets

func _wait(seconds_):
	return get_tree().create_timer(seconds_).timeout

# eclair blanc + petite secousse du combattant touche
func _hitEffect(fighter_:Node2D, strong_):
	var origin=fighter_.position
	var amplitude=4 if strong_ else 2
	var tween=fighter_.create_tween()
	fighter_.modulate=Color(3, 3, 3)
	tween.tween_property(fighter_, "modulate", Color.WHITE, 0.2)
	for i in 4:
		var side=1 if i%2==0 else -1
		tween.parallel().tween_property(fighter_, "position", origin+Vector2(amplitude*side, 0), 0.04).set_delay(i*0.04)
	tween.tween_property(fighter_, "position", origin, 0.04)
	if strong_:
		_shakeScreen()

func _shakeScreen():
	var tween=create_tween()
	for i in 6:
		tween.tween_property(self, "position", Vector2(rng.randi_range(-3, 3), rng.randi_range(-2, 2)), 0.03)
	tween.tween_property(self, "position", Vector2.ZERO, 0.03)

# nombre (ou texte) qui jaillit au-dessus du combattant
func _popText(fighter_:Node2D, text_, color_, big_=false):
	var label=Label.new()
	label.theme=DefaultTheme
	label.text=text_
	label.z_index=10
	label.add_theme_color_override("font_color", color_)
	label.add_theme_color_override("font_outline_color", COLOR_OUTLINE)
	label.add_theme_constant_override("outline_size", 4)
	label.add_theme_font_size_override("font_size", 24 if big_ else 16)
	add_child(label)
	label.reset_size()
	label.position=fighter_.getHeadPosition()-Vector2(label.size.x/2, label.size.y)
	var tween=label.create_tween()
	tween.tween_property(label, "position:y", label.position.y-14, 0.6).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(label, "modulate:a", 0.0, 0.3).set_delay(0.5)
	tween.tween_callback(label.queue_free)

func _trad(id_):
	return GlobalGame.getTraductionById(id_)
