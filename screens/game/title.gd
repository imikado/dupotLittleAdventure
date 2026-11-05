extends Node2D

# Ecran titre : Gordon devant sa maison, forets en parallaxe qui se balancent
# doucement, feuilles qui tombent, logo qui rebondit puis invitation a appuyer.
# On passe au menu sur un appui ou a la fin du Timer.

const KEYBOARD_OS_LIST=["HTML5","Web","X11","Linux", "FreeBSD", "NetBSD", "OpenBSD", "BSD","Windows"]

# balancement de la "camera" : decalage max de chaque calque, en pixels
const SWAY_SPEED=0.35
const SWAY_FAR=1
const SWAY_NEAR=3
const SWAY_FRONT=5

const PRESS_DELAY=1.2
const BLINK_TIME=0.5

var _leaving=false
var _keyboard=false

func _ready():
	$logo.playIntro()

	_keyboard=KEYBOARD_OS_LIST.find(OS.get_name())!=-1
	if _keyboard:
		GlobalPlayer.disableTouch()
		GlobalPlayer.disableDialogAnimation()

	$front/gordon/sprite.sprite_frames=_gordonFrames()
	$front/gordon/sprite.play("idle")

	var pressKey=$pressKey
	pressKey.text=GlobalGame.getTraductionById(GlobalGame.TRAD_TITLE_PRESS_KEY if _keyboard else GlobalGame.TRAD_TITLE_TOUCH)
	pressKey.visible=false
	# clignotement franc (visible / cache) : pas de fondu sur du pixel art
	var tween=create_tween()
	tween.tween_interval(PRESS_DELAY)
	tween.tween_callback(func(): _blink())

func _blink():
	var tween=create_tween().set_loops()
	tween.tween_callback(func(): $pressKey.visible=true)
	tween.tween_interval(BLINK_TIME)
	tween.tween_callback(func(): $pressKey.visible=false)
	tween.tween_interval(BLINK_TIME*0.6)

func _process(_delta):
	var sway=sin(Time.get_ticks_msec()/1000.0*SWAY_SPEED)
	# decalages entiers : le pixel art reste net
	$far.position.x=round(sway*SWAY_FAR)
	$near.position.x=round(sway*SWAY_NEAR)
	$ground.position.x=round(sway*SWAY_FRONT)
	$front.position.x=round(sway*SWAY_FRONT)

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

func _unhandled_input(event):
	var pressed=(event is InputEventKey or event is InputEventJoypadButton or event is InputEventMouseButton or event is InputEventScreenTouch) and event.is_pressed()
	if pressed and !event.is_echo():
		_goToMenu()

func _on_Timer_timeout():
	_goToMenu()

func _goToMenu():
	if _leaving:
		return
	_leaving=true
	SceneTransition.change_scene("res://screens/game/menu.tscn")
