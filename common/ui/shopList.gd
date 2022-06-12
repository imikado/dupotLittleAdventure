extends CanvasLayer

signal buyItem(item_)
signal closePopup

var shopItemList=[]
var shopItemSelected

var itemClass=preload("res://common/class/item_class.gd")
var shopItemClass=preload("res://common/class/shopItem_class.gd")

var patternItem=null

func _ready():
	getWindow().visible=false
	getSideInfo().visible=false

#access
func getWindow():
	return $window
	
func getGrid():
	return $window/HBoxContainer/GridContainer

func getSideInfo():
	return $window/HBoxContainer/sideInfo

func getBuyButton():
	return getSideInfo().get_node("buyButton")
	
func setShopItemList(shopItemList_):
	shopItemList=shopItemList_
	pass
	
func hide():
	getWindow().visible=false
	
func show():
	getWindow().visible=true
	if patternItem==null:
		var exampleItem=getGrid().get_node("item")
		patternItem=exampleItem.duplicate()
		exampleItem.queue_free()
	
		for shopItem in shopItemList:
			if shopItem.item!=null:
				var realItem=GlobalItems.getItem(shopItem.item)
				var newItem=patternItem.duplicate()
				newItem.setImage(realItem.getTexture())
				newItem.connect("button_down",self,"_on_pressed_selected",[shopItem])
			
				getGrid().add_child(newItem)
			else:
				print(shopItem)

func _on_pressed_selected(shopItem_):
	shopItemSelected=shopItem_
	
	var realItem=GlobalItems.getItem(shopItemSelected.item)
	getSideInfo().visible=true
	getSideInfo().get_node("title").text=realItem.name
	getSideInfo().get_node("description").text=realItem.description
	getSideInfo().get_node("HBoxContainer/price").text=str(shopItemSelected.price)

	var buyButton=getBuyButton()
	buyButton.connect("button_down",self,"_on_pressed_buy")

	if GlobalPlayer.canSpendGems(shopItemSelected.price) && false==GlobalPlayer.hasItem(shopItemSelected.item):
		buyButton.disabled=false
	else:
		buyButton.disabled=true
		
func _on_pressed_buy():
	GlobalPlayer.spendGems(shopItemSelected.price)
	GlobalPlayer.addItemEvenIfExist(shopItemSelected.item)
	emit_signal("buyItem",shopItemSelected.item)
	getWindow().visible=false


func _on_closeButton_pressed():
	getWindow().visible=false
	emit_signal("buyItem",null)
