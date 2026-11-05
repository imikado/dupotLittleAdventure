extends CanvasLayer

signal equipItem(item_)
signal useItem(item)

signal openInventory
signal closeInventory

var itemList=[]

var itemClass=preload("res://common/class/item_class.gd")
var exampleItem

var patternItem=null

var itemSelected=null

# comme a la boutique : une seule case cochee, celle dont on lit la fiche
var itemGroup=ButtonGroup.new()
var itemButtons={}

const COUNT_OUTLINE=Color(0.13, 0.125, 0.2)
const COUNT_MARGIN=1
const EQUIPPED_COLOR=Color(1.2, 1.05, 0.6)

func _ready():
	getWindow().visible=false
	getSideInfo().visible=false
	$window2.visible=false
	
	var exampleItemTmp=getGrid().get_node("item")
	exampleItem=exampleItemTmp.duplicate()
	exampleItemTmp.queue_free()
	
	getWindow().get_node("title").text=GlobalGame.getTraductionById(GlobalGame.TRAD_UI_INVENTORY)
	getEquipButton().text=GlobalGame.getTraductionById(GlobalGame.TRAD_UI_EQUIP)
	getDisplayButton().text=GlobalGame.getTraductionById(GlobalGame.TRAD_UI_DISPLAY)
	getUseButton().text=GlobalGame.getTraductionById(GlobalGame.TRAD_UI_USE)
	

# le modèle d'objet est hors de l'arbre : il faut le libérer soi-même
func _exit_tree():
	if exampleItem!=null:
		exampleItem.free()
		exampleItem=null


func emitOpenInventory():
	emit_signal("openInventory")
	
func emitCloseInventory():
	emit_signal("closeInventory")

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
	
func hideWindow():
	getWindow().visible=false
	emitCloseInventory()
	
func showWindow():
	getWindow().visible=true
	
	getSideInfo().visible=false
	
	for itemToReset in getGrid().get_children():
		getGrid().remove_child(itemToReset)
		itemToReset.queue_free()
	
	itemButtons={}
	patternItem=exampleItem.duplicate()

	# un seul emplacement par objet, avec le nombre d'exemplaires
	var uniqueItemList=[]
	for item in itemList:
		if !uniqueItemList.has(item):
			uniqueItemList.append(item)

	for item in uniqueItemList:
		var realItem=GlobalItems.getItem(item)
		var newItem=patternItem.duplicate()
		newItem.setImage(realItem.getTexture())
		newItem.button_group=itemGroup
		itemButtons[item]=newItem
		newItem.connect("button_down", Callable(self, "_on_pressed_selected").bind(item))
		# la description suit le curseur (clavier / manette)
		newItem.connect("focus_entered", Callable(self, "_on_pressed_selected").bind(item))
		var count=itemList.count(item)
		if count > 1:
			newItem.add_child(_makeCountLabel(count))
		if _isEquipped(item):
			newItem.add_theme_stylebox_override("normal", _equippedStyle(newItem))
	
		getGrid().add_child(newItem)
	
	# focus sur le premier objet pour la navigation clavier / manette
	if getGrid().get_child_count() > 0:
		getGrid().get_child(0).grab_focus()
	else:
		getWindow().get_node("closeButton").grab_focus()

func _isEquipped(item_):
	return GlobalPlayer.hasEquipment() and int(GlobalPlayer.getEquipment())==int(item_)

# "x3" en bas a droite de l'emplacement
func _makeCountLabel(count_):
	var label=Label.new()
	label.text="x"+str(count_)
	label.add_theme_color_override("font_outline_color", COUNT_OUTLINE)
	label.add_theme_constant_override("outline_size", 2)
	label.mouse_filter=Control.MOUSE_FILTER_IGNORE
	# le label couvre l'emplacement, le texte est cale en bas a droite
	label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	label.offset_right=-COUNT_MARGIN
	label.offset_bottom=-COUNT_MARGIN
	label.horizontal_alignment=HORIZONTAL_ALIGNMENT_RIGHT
	label.vertical_alignment=VERTICAL_ALIGNMENT_BOTTOM
	return label

# emplacement dore pour l'objet equipe
func _equippedStyle(button_:Button):
	var style=button_.get_theme_stylebox("normal").duplicate()
	style.modulate_color=EQUIPPED_COLOR
	return style

func _on_pressed_selected(item_):
	if itemButtons.has(item_):
		itemButtons[item_].button_pressed=true

	var realItem=GlobalItems.getItem(item_)
	getSideInfo().visible=true
	getSideInfo().get_node("title").text=realItem.getName()
	getSideInfo().get_node("description").text=realItem.getDescription()

	itemSelected=item_

	var equipButton=getEquipButton()
	if not equipButton.button_down.is_connected(_on_pressed_equip):
		equipButton.button_down.connect(_on_pressed_equip)

	var displayButton=getDisplayButton()
	if not displayButton.button_down.is_connected(_on_pressed_display):
		displayButton.button_down.connect(_on_pressed_display)

	var useButton=getUseButton()
	if not useButton.button_down.is_connected(_on_pressed_use):
		useButton.button_down.connect(_on_pressed_use)

	if realItem.type==itemClass.TYPE.TOOL or realItem.type==itemClass.TYPE.WEAPON:
		equipButton.visible=true
		# objet deja equipe : le bouton le signale
		var equipped=_isEquipped(item_)
		equipButton.disabled=equipped
		equipButton.text=GlobalGame.getTraductionById(GlobalGame.TRAD_UI_EQUIPPED if equipped else GlobalGame.TRAD_UI_EQUIP)
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
	emitCloseInventory()

func _on_pressed_display():
	#display map zoomed
	$window2.visible=true
	$window2/closeButton2.grab_focus()
	$window2/TextureRect.texture=load("res://common/items/maps/gormonstar-map-zoom.png")

func _on_pressed_use():
	GlobalPlayer.useItem(itemSelected)
	emit_signal("useItem",itemSelected)
	getWindow().visible=false
	emitCloseInventory()

# Echap : ferme la carte, sinon l'inventaire (renvoie false si rien n'etait ouvert)
func closeTopWindow():
	if $window2.visible:
		_on_closeButton2_pressed()
		return true
	if getWindow().visible:
		_on_closeButton_pressed()
		return true
	return false

func _on_closeButton_pressed():
	getWindow().visible=false
	emitCloseInventory()


# la carte se ferme sur l'inventaire, toujours ouvert
func _on_closeButton2_pressed():
	$window2.visible=false
	getDisplayButton().grab_focus()
