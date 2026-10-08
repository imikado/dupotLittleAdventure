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
	getWindow().get_node("title").text=GlobalGame.getTraductionById(GlobalGame.TRAD_UI_SHOP)

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
	
func hideWindow():
	getWindow().visible=false
	
func showWindow():
	getWindow().visible=true
	if patternItem==null:
		var exampleItem=getGrid().get_node("item")
		patternItem=exampleItem.duplicate()
		getGrid().remove_child(exampleItem)
		exampleItem.queue_free()
	
		for shopItem in shopItemList:
			if shopItem.item!=null:
				var realItem=GlobalItems.getItem(shopItem.item)
				var newItem=patternItem.duplicate()
				newItem.setImage(realItem.getTexture())
				newItem.connect("button_down", Callable(self, "_on_pressed_selected").bind(shopItem))
			
				getGrid().add_child(newItem)
			else:
				print(shopItem)
	# focus sur le premier objet pour la navigation clavier / manette
	if getGrid().get_child_count() > 0:
		getGrid().get_child(0).grab_focus()

func _on_pressed_selected(shopItem_):
	shopItemSelected=shopItem_
	
	var realItem=GlobalItems.getItem(shopItemSelected.item)
	getSideInfo().visible=true
	getSideInfo().get_node("title").text=realItem.name
	getSideInfo().get_node("description").text=realItem.description
	getSideInfo().get_node("HBoxContainer/price").text=str(shopItemSelected.price)

	var buyButton=getBuyButton()
	if not buyButton.button_down.is_connected(_on_pressed_buy):
		buyButton.button_down.connect(_on_pressed_buy)

	var canAfford=GlobalPlayer.canSpendGems(shopItemSelected.price)
	var owned=GlobalPlayer.hasItem(shopItemSelected.item)
	buyButton.disabled=!canAfford or owned
	buyButton.text=GlobalGame.getTraductionById(GlobalGame.TRAD_UI_OWNED if owned else GlobalGame.TRAD_UI_BUY)
	# prix en rouge quand on n'a pas assez de gemmes
	var priceLabel=getSideInfo().get_node("HBoxContainer/price")
	if canAfford:
		priceLabel.remove_theme_color_override("font_color")
	else:
		priceLabel.add_theme_color_override("font_color", Color(0.75, 0.15, 0.2))
		
func _on_pressed_buy():
	GlobalPlayer.spendGems(shopItemSelected.price)
	GlobalPlayer.addItemEvenIfExist(shopItemSelected.item)
	emit_signal("buyItem",shopItemSelected.item)
	getWindow().visible=false


func _on_closeButton_pressed():
	getWindow().visible=false
	emit_signal("buyItem",null)
