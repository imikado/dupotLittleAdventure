extends CanvasLayer

signal save
signal quit

signal equipItem(item_)
signal useItem(item_)

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
	pass # Replace with function body.

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
	pass # Replace with function body.


func _on_btnSave_button_down():
	emit_signal("save")	
	$btnBlock.visible=false
	$saved.visible=true
	$savedTimer.start()


func _on_btnQuit_button_down():
	$confirmation.visible=true
	$btnBlock.visible=false

func _on_btnInventory_button_down():
	$btnBlock.visible=false
	$inventoryList.show()


func _on_btnYes_button_down():
	emit_signal("quit")



func _on_btnNo_button_down():
	$confirmation.visible=false
	pass # Replace with function body.


func _on_inventoryList_equipItem(item_):
	emit_signal("equipItem",item_)


func _on_btnCancell_button_down():
	$btnBlock.visible=false
	pass # Replace with function body.


func _on_savedTimer_timeout():
	$saved.visible=false
	pass # Replace with function body.


func _on_inventoryList_useItem(item_):
	emit_signal("useItem",item_)
	reloadLife()


func _on_player_pressMenu():
	_on_Button_button_down()
	$btnBlock/btnInventory.grab_focus()
	pass # Replace with function body.
