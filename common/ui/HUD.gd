extends CanvasLayer

signal save
signal quit

signal equipItem(item_)
signal useItem(item_)
signal refreshTouchUi

signal openMenu
signal closeMenu

const MENU_SAVE=0
const MENU_INVENTORY=1
const MENU_QUIT=2

# Called when the node enters the scene tree for the first time.
func _ready():
	setLife(GlobalPlayer.getLife())
	setGems(GlobalPlayer.getGemsBalance())
	setXp(GlobalPlayer.getXp())
	
	$btnBlock.visible=false
	$confirmation.visible=false
	
	$inventoryList.setItemList(GlobalPlayer.getItemsList())
	
	$parameters.visible=false
	
	

func openMenu():
	emit_signal("openMenu")

func closeMenu():
	emit_signal("closeMenu")

func reloadGems():
	setGems(GlobalPlayer.getGemsBalance())
	
func reloadInventory():
	$inventoryList.setItemList(GlobalPlayer.getItemsList())
	
func reloadLife():
	setLife(GlobalPlayer.getLife())

func reloadXp():
	setXp(GlobalPlayer.getXp())

	

func setLife(life_):
	$Control/life.text=str(life_)
	
func setGems(gems_):
	$Control/gem.text=str(gems_)

func setXp(xp_):
	$Control/xp.text=str(xp_)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_button_down():
	$btnBlock.visible=true
	openMenu()


func _on_btnSave_button_down():
	emit_signal("save")
	$btnBlock.visible=false
	$saved.visible=true
	$savedTimer.start()
	closeMenu()

func _on_btnQuit_button_down():
	$confirmation.visible=true
	$confirmation/btnYes.grab_focus()
	$btnBlock.visible=false

func _on_btnInventory_button_down():
	$btnBlock.visible=false
	$inventoryList.show()


func _on_btnYes_button_down():
	emit_signal("quit")
	closeMenu()


func _on_btnNo_button_down():
	$confirmation.visible=false
	closeMenu()

func _on_inventoryList_equipItem(item_):
	emit_signal("equipItem",item_)
	closeMenu()

func _on_btnCancell_button_down():
	$btnBlock.visible=false
	closeMenu()


func _on_savedTimer_timeout():
	$saved.visible=false
	pass # Replace with function body.


func _on_inventoryList_useItem(item_):
	emit_signal("useItem",item_)
	reloadLife()
	closeMenu()

func _on_player_pressMenu():
	_on_Button_button_down()
	$btnBlock/btnInventory.grab_focus()


func _on_btnParameters_button_down():
	$btnBlock.visible=false
	$parameters.visible=true
	
	$parameters/touchUiEnabled.grab_focus()
	
	if(GlobalPlayer.isTouchEnabled()):
		$parameters/touchUiEnabled.pressed=true
	else:
		$parameters/touchUiEnabled.pressed=false

	if(GlobalPlayer.isDialogAnimationEnabled()):
		$parameters/dialogAnimationEnabled.pressed=true
	else:
		$parameters/dialogAnimationEnabled.pressed=false


func _on_saveParameters_button_down():
	$parameters.visible=false
	emit_signal("refreshTouchUi")
	closeMenu()


func _on_touchUiEnabled_toggled(button_pressed):
	if(button_pressed):
		GlobalPlayer.enableTouch()
	else:
		GlobalPlayer.disableTouch()
	pass # Replace with function body.


func _on_dialogAnimationEnabled_toggled(button_pressed):
	if(button_pressed):
		GlobalPlayer.enableDialogAnimation()
	else:
		GlobalPlayer.disableDialogAnimation()
	pass # Replace with function body.


func _on_inventoryList_closeInventory():
	closeMenu()
	pass # Replace with function body.
