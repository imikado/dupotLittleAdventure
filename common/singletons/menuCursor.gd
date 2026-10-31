extends CanvasLayer

# Curseur "main" des menus (style 16 bits) : il se place a gauche du bouton
# qui a le focus, quel que soit le menu, et oscille doucement.
# Il joue aussi le son de deplacement quand le focus change.

const CURSOR_TEXTURE=preload("res://common/ui/simpleDialog/cursor.png")
# les boutons pastilles (Menu, X, FR/EN) ont leur propre cadre de focus
const NO_CURSOR_VARIATION=&"ChipButton"
const BOB_PERIOD=280

var _cursor:Sprite2D
var _lastFocus=null

func _ready():
	layer=90
	process_mode=Node.PROCESS_MODE_ALWAYS
	_cursor=Sprite2D.new()
	_cursor.texture=CURSOR_TEXTURE
	_cursor.centered=false
	_cursor.visible=false
	add_child(_cursor)
	get_tree().node_added.connect(_on_node_added)

func _process(_delta):
	var focus=get_viewport().gui_get_focus_owner()
	if focus!=_lastFocus:
		if _lastFocus!=null and is_instance_valid(focus) and _isMenuButton(focus):
			Sfx.play(Sfx.CURSOR)
		_lastFocus=focus
	if !is_instance_valid(focus) or !_isMenuButton(focus):
		_cursor.visible=false
		return
	var transform=focus.get_global_transform_with_canvas()
	var anchor=transform*Vector2(1, focus.size.y/2)
	var bob=1 if (Time.get_ticks_msec()/BOB_PERIOD)%2==0 else 0
	_cursor.position=Vector2(round(anchor.x)+bob, round(anchor.y-CURSOR_TEXTURE.get_height()/2.0)-1)
	_cursor.visible=true

func _isMenuButton(control_):
	return control_ is Button and control_.is_visible_in_tree() and control_.text!="" \
		and control_.theme_type_variation!=NO_CURSOR_VARIATION

# chaque bouton du jeu fait "bip" quand on le valide
func _on_node_added(node_):
	if node_ is BaseButton and !node_.pressed.is_connected(_on_button_pressed):
		node_.pressed.connect(_on_button_pressed)

func _on_button_pressed():
	Sfx.play(Sfx.CONFIRM)
