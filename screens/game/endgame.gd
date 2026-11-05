extends CanvasLayer

# Fin du jeu par-dessus le village : fete autour du puits repare (villageois
# des trois villages qui sautillent, BeVil, fanions, confettis), puis generique
# qui defile, et enfin la fenetre parchemin avec le retour au menu.
# Un appui fait passer a l'etape suivante.

signal backToMenu

enum {HIDDEN, PARTY, CREDITS, WINDOW}

const PARTY_TIME=6.0
const CREDITS_SPEED=18.0
# un appui n'est pris en compte qu'apres ce delai (evite de sauter la fete
# avec l'appui qui a termine le dialogue)
const INPUT_DELAY=1.0

const HOP_HEIGHT=4
const HOP_TIME=0.35

# [scene, animation, position, planche de remplacement, miroir]
const GUESTS=[
	["res://screens/tree-village/shop/assets/seller/seller.tscn", "default", Vector2(70, 100), "", false],
	["res://screens/tree-village/gem-house/assets/seller.tscn", "default", Vector2(98, 128), "", false],
	["res://common/characters/mom.tscn", "default", Vector2(128, 116), "", false],
	["res://screens/tree-village/assets/craftsman.tscn", "default", Vector2(194, 116), "", true],
	["res://screens/bear-village/assets/bear.tscn", "default", Vector2(226, 100), "", false],
	["res://screens/bear-village/assets/bear.tscn", "default", Vector2(252, 128), "", true],
	["res://screens/crabs-village/characters/welcome-boy.tscn", "default", Vector2(36, 140), "", false],
	["res://screens/crabs-village/characters/villager.tscn", "default", Vector2(286, 144), "res://screens/crabs-village/characters/villager/villager-idle-orange.png", false],
	["res://screens/crabs-village/characters/villager.tscn", "default", Vector2(294, 108), "res://screens/crabs-village/characters/villager/villager-idle-blue.png", false],
]
const GORDON_POSITION=Vector2(160, 138)
const SHADOW=preload("res://common/characters/shadow.png")

# BeVil qui volent en huit au-dessus du puits : [centre, rayon, vitesse, phase]
const BEES=[[Vector2(132, 34), Vector2(26, 8), 1.3, 0.0], [Vector2(190, 40), Vector2(22, 7), 1.6, 2.0]]

# lignes du generique : [style, cle de traduction]
var creditLines=[
	["text", GlobalGame.TRAD_CREDITS_GAME],
	["space", ""],
	["heading", GlobalGame.TRAD_CREDITS_CAST],
	["text", GlobalGame.TRAD_WORD_GORDON],
	["text", GlobalGame.TRAD_WORD_GORDONMOM],
	["text", GlobalGame.TRAD_WORD_ARTISAN],
	["text", GlobalGame.TRAD_WORD_VENDEUR],
	["text", GlobalGame.TRAD_WORD_APICULTEUR],
	["text", GlobalGame.TRAD_CREDITS_BEARS],
	["text", GlobalGame.TRAD_CREDITS_BEVIL],
	["text", GlobalGame.TRAD_CREDITS_CRABS],
	["text", GlobalGame.TRAD_CREDITS_SPIDER],
	["space", ""],
	["heading", GlobalGame.TRAD_CREDITS_FONT_TITLE],
	["text", GlobalGame.TRAD_CREDITS_FONT],
	["space", ""],
	["heading", GlobalGame.TRAD_CREDITS_ENGINE_TITLE],
	["text", GlobalGame.TRAD_CREDITS_ENGINE],
	["space", ""],
	["heading", GlobalGame.TRAD_CREDITS_LICENSE_TITLE],
	["text", GlobalGame.TRAD_CREDITS_LICENSE],
	["space", ""],
	["heading", GlobalGame.TRAD_CREDITS_MORE],
]

var step=HIDDEN
var _stepTime=0.0
var _time=0.0
var _hoppers=[]
var _bees=[]
var _rollY=0.0

func _ready():
	visible=false
	refreshUi()

func refreshUi():
	$window/list/title.text=GlobalGame.getTraductionById(GlobalGame.TRAD_END_TITLE)
	$window/list/message.text=GlobalGame.getTraductionById(GlobalGame.TRAD_END_MESSAGE)
	$window/list/button.text=GlobalGame.getTraductionById(GlobalGame.TRAD_LABEL_RETOURAUMENU)
	$party/partyLabel.text=GlobalGame.getTraductionById(GlobalGame.TRAD_END_PARTY)

func showEnd():
	refreshUi()
	visible=true
	_buildParty()
	_buildCredits()
	$credits.visible=false
	$backdrop.visible=false
	$window.visible=false
	_startParty()

#--- etape 1 : la fete

func _buildParty():
	var actors=$party/scene/actors
	for guest in GUESTS:
		var sheet=load(guest[3]) if guest[3]!="" else null
		_addActor(actors, _framesFrom(guest[0], guest[1], sheet), guest[1], guest[2], guest[4])
	_addActor(actors, _gordonFrames(), "idle", GORDON_POSITION, false)
	for bee in BEES:
		var sprite=AnimatedSprite2D.new()
		sprite.sprite_frames=_framesFrom("res://common/moving-fighters/bee.tscn", "default", null)
		sprite.play("default")
		sprite.frame=randi() % sprite.sprite_frames.get_frame_count("default")
		$party/scene/bees.add_child(sprite)
		_bees.append({"sprite":sprite, "data":bee})

# ombre au sol + sprite qui sautille au-dessus
func _addActor(parent_, frames_, animation_, position_, flip_):
	var actor=Node2D.new()
	actor.position=position_
	var shadow=Sprite2D.new()
	shadow.texture=SHADOW
	shadow.position=Vector2(0, 16)
	actor.add_child(shadow)
	var sprite=AnimatedSprite2D.new()
	sprite.sprite_frames=frames_
	sprite.flip_h=flip_
	sprite.play(animation_)
	sprite.frame=randi() % frames_.get_frame_count(animation_)
	actor.add_child(sprite)
	parent_.add_child(actor)
	_hoppers.append({"sprite":sprite, "period":randf_range(0.9, 1.5), "phase":randf()})

# reprend les images d'un personnage existant sans instancier son script
# (zones de dialogue, collisions...) ; planche de remplacement possible
func _framesFrom(scenePath_, animation_, sheet_):
	var node=load(scenePath_).instantiate()
	var source:SpriteFrames
	if node is AnimatedSprite2D:
		source=node.sprite_frames
	else:
		source=node.find_children("*", "AnimatedSprite2D", true, false)[0].sprite_frames
	node.free()
	if sheet_==null:
		return source
	var frames=SpriteFrames.new()
	frames.set_animation_speed("default", source.get_animation_speed(animation_))
	frames.set_animation_loop("default", true)
	for i in source.get_frame_count(animation_):
		var atlas=AtlasTexture.new()
		atlas.atlas=sheet_
		atlas.region=source.get_frame_texture(animation_, i).region
		frames.add_frame("default", atlas, source.get_frame_duration(animation_, i))
	return frames

# respiration puis clignement, comme sur la carte (_gordonFrames de macro-map.gd)
func _gordonFrames():
	var frames=SpriteFrames.new()
	frames.add_animation("idle")
	frames.set_animation_speed("idle", 8.0)
	var texture:Texture2D=load("res://common/characters/player/Player-idle.png")
	var durations=[6, 6, 10, 1]
	for i in texture.get_width()/32:
		var atlas=AtlasTexture.new()
		atlas.atlas=texture
		atlas.region=Rect2(i*32, 0, 32, 32)
		frames.add_frame("idle", atlas, durations[i] if i < durations.size() else 1)
	return frames

func _startParty():
	_setStep(PARTY)
	Sfx.play(Sfx.VICTORY)
	var party=$party
	party.modulate.a=0.0
	var tween=create_tween()
	tween.tween_property(party, "modulate:a", 1.0, 0.5)
	tween.tween_callback(func():
		$party/scene/rain.emitting=true
		$party/scene/burstLeft.emitting=true
		$party/scene/burstRight.emitting=true)

#--- etape 2 : le generique

func _buildCredits():
	var roll=$credits/roll
	for line in creditLines:
		if line[0]=="space":
			var space=Control.new()
			space.custom_minimum_size=Vector2(0, 8)
			roll.add_child(space)
			continue
		var label=Label.new()
		label.text=GlobalGame.getTraductionById(line[1])
		label.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
		label.theme_type_variation=&"HeadingLabel" if line[0]=="heading" else &"NameLabel"
		roll.add_child(label)

func _startCredits():
	_setStep(CREDITS)
	var credits=$credits
	credits.visible=true
	credits.modulate.a=0.0
	_rollY=get_viewport().get_visible_rect().size.y
	$credits/roll.position.y=_rollY
	var tween=create_tween()
	tween.tween_property(credits, "modulate:a", 1.0, 0.5)
	# le titre de la fete laisse la place au generique
	tween.parallel().tween_property($party/partyLabel, "modulate:a", 0.0, 0.3)
	$credits/roll/logoBox/logo.playIntro()

#--- etape 3 : la fenetre de fin

func _startWindow():
	_setStep(WINDOW)
	var backdrop=$backdrop
	var window=$window
	backdrop.visible=true
	window.visible=true
	# le fond s'assombrit, puis la fenetre se deplie
	backdrop.modulate.a=0.0
	window.pivot_offset=window.size/2
	window.scale=Vector2(1, 0.1)
	window.modulate.a=0.0
	var tween=create_tween()
	tween.tween_property(backdrop, "modulate:a", 1.0, 0.4)
	tween.tween_property(window, "modulate:a", 1.0, 0.05)
	tween.tween_property(window, "scale:y", 1.0, 0.15).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	await tween.finished
	$window/list/button.grab_focus()

func _setStep(step_):
	step=step_
	_stepTime=0.0

func _process(delta):
	if step==HIDDEN:
		return
	_time+=delta
	_stepTime+=delta
	_animateParty()
	if step==PARTY and _stepTime >= PARTY_TIME:
		_startCredits()
	elif step==CREDITS:
		_rollY-=CREDITS_SPEED*delta
		# position entiere : le texte reste net en defilant
		$credits/roll.position.y=round(_rollY)
		if _rollY+$credits/roll.size.y < 0:
			_startWindow()

func _animateParty():
	for hopper in _hoppers:
		var cycle=fmod(_time/hopper.period+hopper.phase, 1.0)*hopper.period
		var height=0.0
		if cycle < HOP_TIME:
			height=sin(PI*cycle/HOP_TIME)*HOP_HEIGHT
		hopper.sprite.position.y=-round(height)
	for bee in _bees:
		var data=bee.data
		var angle=_time*data[2]+data[3]
		# trajectoire en huit, tournee vers le sens du vol
		var offset=Vector2(sin(angle)*data[1].x, sin(angle*2)*data[1].y)
		bee.sprite.position=(data[0]+offset).round()
		bee.sprite.flip_h=cos(angle) < 0

func _unhandled_input(event):
	if step==HIDDEN or step==WINDOW or _stepTime < INPUT_DELAY:
		return
	var pressed=(event is InputEventKey or event is InputEventJoypadButton or event is InputEventMouseButton or event is InputEventScreenTouch) and event.is_pressed() and !event.is_echo()
	if !pressed:
		return
	get_viewport().set_input_as_handled()
	if step==PARTY:
		_startCredits()
	elif step==CREDITS:
		_startWindow()

func _on_button_pressed():
	emit_signal("backToMenu")
	SceneTransition.change_scene("res://screens/game/menu.tscn")
