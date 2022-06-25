extends CanvasLayer

signal movePlayer(joystickVector_)

signal pushButton
signal releaseButton
 
var joystick_speed = 0;
var joystick_angle = 0;
var joystick_vector = Vector2();

var equipment=null

var _isEnable=true

var keyboardEnabled=false

func _ready():
	if GlobalPlayer.hasEquipment():
		setEquipment(GlobalPlayer.getEquipment())
		
	if(GlobalPlayer.isTouchEnabled()):
		enable()
	else:
		disable()


func enable():
	if !GlobalPlayer.isTouchEnabled():
		return
		
	_isEnable=true
	if equipment!=null:
		$button.visible=true
	$"joystick-big".visible=true

func disable():
	_isEnable=false
	$button.visible=false
	$"joystick-big".visible=false

func _on_button_pushButton():
	if _isEnable:
		emit_signal("pushButton")

func _on_button_releaseButton():
	if _isEnable:
		emit_signal("releaseButton")

func _on_joystickbig_moveJoystick(joystickVector_):
	if _isEnable:
		emit_signal("movePlayer",joystickVector_)

func enableButton():
	$button.visible=true

func setEquipment(item_):
	var realItem=GlobalItems.getItem(item_)
	$button/Sprite.texture=realItem.getTexture()
	enableButton()
	

func _on_HUD_equipItem(item_):
	setEquipment(item_)


func _on_HUD_refreshTouchUi():
	if(GlobalPlayer.isTouchEnabled()):
		enable()
	else:
		disable()
	pass # Replace with function body.


func _on_player_useKeyboard():
	keyboardEnabled=true
	_on_HUD_refreshTouchUi()
