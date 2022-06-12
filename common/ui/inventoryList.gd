extends CanvasLayer

signal equipItem(item_)
signal useItem(item)

var itemList=[]

var itemClass=preload("res://common/class/item_class.gd")
var exampleItem

var patternItem=null

var itemSelected=null

func _ready():
	getWindow().visible=false
	getSideInfo().visible=false
	$window2.visible=false
	
	var exampleItemTmp=getGrid().get_node("item")
	exampleItem=exampleItemTmp.duplicate()
	exampleItemTmp.queue_free()

#access
func getWindow():
	return $window
	
func getGrid():
	return $window/HBoxContainer/GridContainer

func getSideInfo():
	return $window/HBoxContainer/sideInfo

func getEquipButton():
	return getSideInfo().get_node("equipButton")
	
func getDisplayButton():
	return getSideInfo().get_node("displayButton")

func getUseButton():
	return getSideInfo().get_node("useButton")


func setItemList(itemList_):
	itemList=itemList_
	pass
	
func hide():
	getWindow().visible=false
	
func show():
	getWindow().visible=true
	
	for itemToReset in getGrid().get_children():
		itemToReset.queue_free()
	
	patternItem=exampleItem.duplicate()

	for item in itemList:
		var realItem=GlobalItems.getItem(item)
		var newItem=patternItem.duplicate()
		newItem.setImage(realItem.getTexture())
		newItem.connect("button_down",self,"_on_pressed_selected",[item])
	
		getGrid().add_child(newItem)
 

func _on_pressed_selected(item_):
	var realItem=GlobalItems.getItem(item_)
	getSideInfo().visible=true
	getSideInfo().get_node("title").text=realItem.name
	getSideInfo().get_node("description").text=realItem.description

	itemSelected=item_

	var equipButton=getEquipButton()
	equipButton.connect("button_down",self,"_on_pressed_equip")

	var displayButton=getDisplayButton()
	displayButton.connect("button_down",self,"_on_pressed_display")

	var useButton=getUseButton()
	useButton.connect("button_down",self,"_on_pressed_use")

	if realItem.type==itemClass.TYPE.TOOL or realItem.type==itemClass.TYPE.WEAPON:
		equipButton.visible=true
	else:
		equipButton.visible=false
		
	if realItem.type==itemClass.TYPE.MAP:
		displayButton.visible=true
	else:
		displayButton.visible=false
	
	if realItem.type==itemClass.TYPE.MAGICPOTION:
		useButton.visible=true
	else:
		useButton.visible=false
	

		
func _on_pressed_equip():
	GlobalPlayer.setEquipment(itemSelected)
	emit_signal("equipItem",itemSelected)
	getWindow().visible=false

func _on_pressed_display():
	#display map zoomed
	$window2.visible=true
	$window2/TextureRect.texture=load("res://common/items/maps/gormonstar-map-zoom.png")

func _on_pressed_use():
	GlobalPlayer.useItem(itemSelected)
	emit_signal("useItem",itemSelected)
	getWindow().visible=false


func _on_closeButton_pressed():
	getWindow().visible=false



func _on_closeButton2_pressed():
	$window2.visible=false
	pass # Replace with function body.
