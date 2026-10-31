extends CanvasLayer

signal buyItem(item_)
signal closePopup

var shopItemList=[]
var shopItemSelected

var itemClass=preload("res://common/class/item_class.gd")
var shopItemClass=preload("res://common/class/shopItem_class.gd")

var patternItem=null

# la fenetre prend la hauteur de son contenu (en pixels du jeu)
const MIN_HEIGHT=90
const MARGIN_BOTTOM=8
const WALLET_GAP=6
# centre un peu sous le milieu de l'ecran pour laisser le HUD visible
const CENTER_SHIFT=9

func _ready():
	getWindow().visible=false
	getSideInfo().visible=false
	getWindow().get_node("title").text=GlobalGame.getTraductionById(GlobalGame.TRAD_UI_SHOP)
	getWindow().get_node("wallet/label").text=GlobalGame.getTraductionById(GlobalGame.TRAD_UI_YOUR_GEMS)
	getNotice().text=GlobalGame.getTraductionById(GlobalGame.TRAD_UI_NOT_ENOUGH_GEMS)

# le modèle d'objet est hors de l'arbre : il faut le libérer soi-même
func _exit_tree():
	if patternItem!=null:
		patternItem.free()
		patternItem=null

#access
func getWindow():
	return $window
	
func getGrid():
	return $window/HBoxContainer/GridContainer

func getSideInfo():
	return $window/HBoxContainer/sideInfo

func getBuyButton():
	return getSideInfo().get_node("buyButton")

func getNotice():
	return getSideInfo().get_node("notice")
	
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
				# la description suit le curseur (clavier / manette)
				newItem.connect("focus_entered", Callable(self, "_on_pressed_selected").bind(shopItem))
			
				getGrid().add_child(newItem)
			else:
				print(shopItem)
	getWindow().get_node("wallet/count").text=str(GlobalPlayer.getGemsBalance())
	await _fitWindow()
	# focus sur le premier objet pour la navigation clavier / manette
	for shopItem in shopItemList:
		if shopItem.item!=null:
			_on_pressed_selected(shopItem)
			break
	if getGrid().get_child_count() > 0:
		getGrid().get_child(0).grab_focus()

# hauteur calee sur l'objet dont la fiche est la plus longue : la fenetre ne
# change pas de taille quand on passe d'un objet a l'autre
func _fitWindow():
	var window=getWindow()
	window.modulate.a=0.0
	var sideHeight=0.0
	for shopItem in shopItemList:
		if shopItem.item!=null:
			_on_pressed_selected(shopItem)
			# le message "pas assez de gemmes" peut apparaitre pour n'importe quel objet
			getNotice().visible=true
			await get_tree().process_frame
			sideHeight=max(sideHeight, getSideInfo().get_combined_minimum_size().y)
	var box=window.get_node("HBoxContainer")
	var wallet=window.get_node("wallet")
	var walletHeight=wallet.get_combined_minimum_size().y
	var leftHeight=getGrid().get_combined_minimum_size().y+WALLET_GAP+walletHeight
	var height=round(max(MIN_HEIGHT, box.position.y+max(sideHeight, leftHeight)+MARGIN_BOTTOM))
	window.offset_top=CENTER_SHIFT-round(height/2)
	window.offset_bottom=window.offset_top+height
	box.size.y=height-box.position.y-MARGIN_BOTTOM
	var gridBg=window.get_node("gridBg")
	gridBg.size.y=height-gridBg.position.y-5
	wallet.position.y=gridBg.position.y+gridBg.size.y-walletHeight-3
	window.modulate.a=1.0

func _on_pressed_selected(shopItem_):
	shopItemSelected=shopItem_
	
	var realItem=GlobalItems.getItem(shopItemSelected.item)
	getSideInfo().visible=true
	getSideInfo().get_node("title").text=realItem.getName()
	getSideInfo().get_node("description").text=realItem.getDescription()
	getSideInfo().get_node("HBoxContainer/price").text=str(shopItemSelected.price)

	var buyButton=getBuyButton()
	if not buyButton.button_down.is_connected(_on_pressed_buy):
		buyButton.button_down.connect(_on_pressed_buy)

	var canAfford=GlobalPlayer.canSpendGems(shopItemSelected.price)
	var owned=GlobalPlayer.hasItem(shopItemSelected.item)
	buyButton.disabled=!canAfford or owned
	buyButton.text=GlobalGame.getTraductionById(GlobalGame.TRAD_UI_OWNED if owned else GlobalGame.TRAD_UI_BUY)
	# on explique pourquoi le bouton est grise
	getNotice().visible=!canAfford and !owned
	# prix en rouge quand on n'a pas assez de gemmes
	var priceLabel=getSideInfo().get_node("HBoxContainer/price")
	if canAfford:
		priceLabel.remove_theme_color_override("font_color")
	else:
		priceLabel.add_theme_color_override("font_color", Color(0.75, 0.12, 0.08))
		
func _on_pressed_buy():
	GlobalPlayer.spendGems(shopItemSelected.price)
	GlobalPlayer.addItemEvenIfExist(shopItemSelected.item)
	emit_signal("buyItem",shopItemSelected.item)
	getWindow().visible=false


func _on_closeButton_pressed():
	getWindow().visible=false
	emit_signal("buyItem",null)
