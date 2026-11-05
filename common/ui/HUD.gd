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

const LOW_LIFE_RATIO=0.3
const MEDIUM_LIFE_RATIO=0.6

const COLOR_LIFE_OK=Color(0.3, 0.9, 0.45)
const COLOR_LIFE_MEDIUM=Color(1, 0.75, 0.25)
const COLOR_LIFE_LOW=Color(0.95, 0.3, 0.3)

@onready var btnBlock=$btnBlock
@onready var confirmation=$confirmation
@onready var parameters=$parameters
@onready var goals=$goals

# journal de quete : objets a reunir pour reparer le puits, et ou les trouver
const GEMHOUSE_SCENE="res://screens/tree-village/gem-house.tscn"
const GEMHOUSE_STEP_FIRSTTIME="first_time"
const GEMHOUSE_STEP_DONE="hasFoundGormonStar"
const NB_GORMONSTAR=5
const GOAL_DONE_COLOR=Color(0.18, 0.45, 0.16)
const GOAL_MISSING_ALPHA=0.35

var displayedGems=0
# frame de fermeture du menu (la meme touche Echap ne doit pas le rouvrir)
var menuClosedFrame=-1
var displayedXp=0

# Called when the node enters the scene tree for the first time.
func _ready():
	displayedGems=GlobalPlayer.getGemsBalance()
	displayedXp=GlobalPlayer.getXp()
	setLife(GlobalPlayer.getLife())
	setGems(displayedGems)
	setXp(displayedXp)

	btnBlock.visible=false
	confirmation.visible=false
	parameters.visible=false
	goals.visible=false
	$modalBackdrop.visible=false
	$saved.visible=false

	$inventoryList.setItemList(GlobalPlayer.getItemsList())

	refreshUi()
	refreshEquipment()

func refreshUi():
	$Control/btnMenu.text=GlobalGame.getTraductionById(GlobalGame.TRAD_UI_MENU)
	$btnBlock/list/title.text=GlobalGame.getTraductionById(GlobalGame.TRAD_UI_PAUSE)
	$btnBlock/list/btnCancell.text=GlobalGame.getTraductionById(GlobalGame.TRAD_UI_RESUME)
	$btnBlock/list/btnInventory.text=GlobalGame.getTraductionById(GlobalGame.TRAD_UI_INVENTORY)
	$btnBlock/list/btnGoals.text=GlobalGame.getTraductionById(GlobalGame.TRAD_UI_GOALS)
	$goals/list/title.text=GlobalGame.getTraductionById(GlobalGame.TRAD_UI_GOALS)
	$goals/list/subtitle.text=GlobalGame.getTraductionById(GlobalGame.TRAD_GOALS_WELL)
	$goals/list/closeGoals.text=GlobalGame.getTraductionById(GlobalGame.TRAD_UI_CLOSE)
	$btnBlock/list/btnSave.text=GlobalGame.getTraductionById(GlobalGame.TRAD_UI_SAVE)
	$btnBlock/list/btnParameters.text=GlobalGame.getTraductionById(GlobalGame.TRAD_UI_SETTINGS)
	$btnBlock/list/btnQuit.text=GlobalGame.getTraductionById(GlobalGame.TRAD_UI_QUIT)
	$confirmation/list/title.text=GlobalGame.getTraductionById(GlobalGame.TRAD_UI_QUIT_CONFIRM)
	$confirmation/list/warning.text=GlobalGame.getTraductionById(GlobalGame.TRAD_UI_QUIT_WARNING)
	$confirmation/list/buttons/btnYes.text=GlobalGame.getTraductionById(GlobalGame.TRAD_UI_YES)
	$confirmation/list/buttons/btnNo.text=GlobalGame.getTraductionById(GlobalGame.TRAD_UI_NO)
	$parameters/list/title.text=GlobalGame.getTraductionById(GlobalGame.TRAD_UI_SETTINGS)
	$parameters/list/touchUiEnabled.text=GlobalGame.getTraductionById(GlobalGame.TRAD_UI_TOUCH)
	$parameters/list/dialogAnimationEnabled.text=GlobalGame.getTraductionById(GlobalGame.TRAD_UI_DIALOG_ANIMATION)
	$parameters/list/soundEnabled.text=GlobalGame.getTraductionById(GlobalGame.TRAD_UI_SOUND)
	$parameters/list/language.text=GlobalGame.getTraductionById(GlobalGame.TRAD_UI_LANGUAGE)
	$parameters/list/saveParameters.text=GlobalGame.getTraductionById(GlobalGame.TRAD_UI_CLOSE)
	$saved/label.text=GlobalGame.getTraductionById(GlobalGame.TRAD_UI_SAVED)

func _process(delta):
	# coeur qui bat quand la vie est basse
	var lowLife=GlobalPlayer.getLife() <= GlobalPlayer.getMaxLife()*LOW_LIFE_RATIO
	if lowLife and (Time.get_ticks_msec()/250)%3==0:
		$Control/lifeIcon.scale=Vector2(1.25, 1.25)
	else:
		$Control/lifeIcon.scale=Vector2.ONE

func _unhandled_input(event):
	# Tab / bouton Y : passe a l'objet suivant (epee, pelle...)
	if event.is_action_pressed("switch_equipment") and !isMenuOpen() and !get_tree().paused:
		switchEquipment()
		get_viewport().set_input_as_handled()
		return
	# I / bouton Select : ouvre l'inventaire
	if event.is_action_pressed("open_inventory") and !isMenuOpen() and !get_tree().paused:
		openInventory()
		get_viewport().set_input_as_handled()
		return
	# Echap / bouton retour : revient en arriere dans les menus
	if !event.is_action_pressed("ui_cancel"):
		return
	if $inventoryList.closeTopWindow():
		pass
	elif goals.visible:
		_on_closeGoals_pressed()
	elif parameters.visible:
		_on_saveParameters_button_down()
	elif confirmation.visible:
		_on_btnNo_button_down()
	elif btnBlock.visible:
		_on_btnCancell_button_down()
	else:
		return
	Sfx.play(Sfx.CANCEL)
	get_viewport().set_input_as_handled()

func isMenuOpen():
	return btnBlock.visible or confirmation.visible or parameters.visible or goals.visible or $inventoryList.getWindow().visible

func emitOpenMenu():
	$modalBackdrop.visible=true
	get_tree().paused=true
	emit_signal("openMenu")

func emitCloseMenu():
	$modalBackdrop.visible=false
	get_tree().paused=false
	menuClosedFrame=Engine.get_process_frames()
	emit_signal("closeMenu")

func reloadGems():
	var gems=GlobalPlayer.getGemsBalance()
	if gems > displayedGems:
		popGain($Control/gem, gems-displayedGems)
		Sfx.play(Sfx.GEM)
	displayedGems=gems
	setGems(gems)

func reloadInventory():
	$inventoryList.setItemList(GlobalPlayer.getItemsList())
	refreshEquipment()

func reloadLife():
	setLife(GlobalPlayer.getLife())

func reloadXp():
	var xp=GlobalPlayer.getXp()
	if xp > displayedXp:
		popGain($Control/xp, xp-displayedXp)
	displayedXp=xp
	setXp(xp)

# petit "+N" qui monte au-dessus d'un compteur
func popGain(label_:Label, value_):
	var pop=Label.new()
	pop.text="+"+str(value_)
	pop.add_theme_color_override("font_color", Color(1, 0.82, 0.4))
	pop.add_theme_color_override("font_outline_color", Color(0.13, 0.125, 0.2))
	pop.add_theme_constant_override("outline_size", 2)
	pop.position=label_.position+Vector2(0, 10)
	$Control.add_child(pop)
	var tween=pop.create_tween()
	tween.tween_property(pop, "position:y", pop.position.y+8, 0.6).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(pop, "modulate:a", 0.0, 0.6).set_delay(0.3)
	tween.tween_callback(pop.queue_free)
	# le compteur s'illumine brievement
	var bump=label_.create_tween()
	bump.tween_property(label_, "modulate", Color(1, 0.82, 0.4), 0.05)
	bump.tween_property(label_, "modulate", Color.WHITE, 0.4)

func setLife(life_):
	var gauge=$Control/lifeGauge
	gauge.max_value=GlobalPlayer.getMaxLife()
	var ratio=float(life_)/max(1, GlobalPlayer.getMaxLife())
	var color=COLOR_LIFE_OK
	if ratio <= LOW_LIFE_RATIO:
		color=COLOR_LIFE_LOW
	elif ratio <= MEDIUM_LIFE_RATIO:
		color=COLOR_LIFE_MEDIUM
	gauge.get_theme_stylebox("fill").bg_color=color
	if !is_inside_tree() or life_ > gauge.value:
		gauge.value=life_
		return
	# la jauge descend en glissant
	create_tween().tween_property(gauge, "value", life_, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func setGems(gems_):
	$Control/gem.text=str(gems_)

func setXp(xp_):
	$Control/xp.text=str(xp_)


func openPauseMenu():
	if isMenuOpen() or menuClosedFrame==Engine.get_process_frames():
		return
	refreshUi()
	btnBlock.visible=true
	emitOpenMenu()
	$btnBlock/list/btnCancell.grab_focus()

func _on_Button_button_down():
	openPauseMenu()


func _on_btnSave_button_down():
	emit_signal("save")
	btnBlock.visible=false
	$saved.visible=true
	$savedTimer.start()
	emitCloseMenu()

func _on_btnQuit_button_down():
	btnBlock.visible=false
	confirmation.visible=true
	$confirmation/list/buttons/btnNo.grab_focus()

func _on_btnInventory_button_down():
	btnBlock.visible=false
	$inventoryList.showWindow()

# icone sac du HUD : inventaire directement, sans passer par la pause
func openInventory():
	if isMenuOpen() or GlobalGame.isDialogOpen():
		return
	emitOpenMenu()
	$inventoryList.showWindow()


func _on_btnYes_button_down():
	confirmation.visible=false
	emitCloseMenu()
	emit_signal("quit")


func _on_btnNo_button_down():
	confirmation.visible=false
	btnBlock.visible=true
	$btnBlock/list/btnQuit.grab_focus()

func _on_inventoryList_equipItem(item_):
	emit_signal("equipItem",item_)
	refreshEquipment()
	emitCloseMenu()

func _on_btnCancell_button_down():
	btnBlock.visible=false
	emitCloseMenu()


func _on_savedTimer_timeout():
	$saved.visible=false


func _on_inventoryList_useItem(item_):
	emit_signal("useItem",item_)
	reloadLife()
	emitCloseMenu()

func _on_player_pressMenu():
	openPauseMenu()


func _on_btnParameters_button_down():
	btnBlock.visible=false
	parameters.visible=true

	$parameters/list/touchUiEnabled.set_pressed_no_signal(GlobalPlayer.isTouchEnabled())
	$parameters/list/dialogAnimationEnabled.set_pressed_no_signal(GlobalPlayer.isDialogAnimationEnabled())
	$parameters/list/soundEnabled.set_pressed_no_signal(GlobalPlayer.isSoundEnabled())

	$parameters/list/touchUiEnabled.grab_focus()


func _on_saveParameters_button_down():
	parameters.visible=false
	emit_signal("refreshTouchUi")
	btnBlock.visible=true
	$btnBlock/list/btnParameters.grab_focus()


func _on_touchUiEnabled_toggled(button_pressed):
	if(button_pressed):
		GlobalPlayer.enableTouch()
	else:
		GlobalPlayer.disableTouch()


func _on_dialogAnimationEnabled_toggled(button_pressed):
	if(button_pressed):
		GlobalPlayer.enableDialogAnimation()
	else:
		GlobalPlayer.disableDialogAnimation()


func _on_soundEnabled_toggled(button_pressed):
	if(button_pressed):
		GlobalPlayer.enableSound()
	else:
		GlobalPlayer.disableSound()


# les dialogues de la scène en cours gardent leur langue : ils sont
# construits au chargement de la scène
func _on_language_pressed():
	GlobalGame.toggleLang()
	refreshUi()


func _on_inventoryList_closeInventory():
	emitCloseMenu()


#--- objectifs

func _on_btnGoals_pressed():
	btnBlock.visible=false
	_buildGoals()
	goals.visible=true
	$goals/list/closeGoals.grab_focus()

func _on_closeGoals_pressed():
	goals.visible=false
	btnBlock.visible=true
	$btnBlock/list/btnGoals.grab_focus()

func _buildGoals():
	var rows=$goals/list/rows
	for child in rows.get_children():
		rows.remove_child(child)
		child.queue_free()
	var goalList=[
		[_getGoalWeaponId(), GlobalGame.TRAD_GOALS_SWORD],
		[GlobalItems.ID.NAILS, GlobalGame.TRAD_GOALS_NAILS],
		[GlobalItems.ID.HONEY, GlobalGame.TRAD_GOALS_BEARS],
		[GlobalItems.ID.BUCKET, GlobalGame.TRAD_GOALS_BEARS],
	]
	for goal in goalList:
		var item=GlobalItems.getItem(goal[0])
		var text=item.getName()+" ("+GlobalGame.getTraductionById(goal[1])+")"
		rows.add_child(_makeGoalRow(item.getTexture(), text, GlobalPlayer.hasItem(goal[0])))
	# quete des etoiles : affichee une fois proposee par le marchand de gemmes
	var gemHouseStep=GlobalScenes.getParamForSceneOr(GEMHOUSE_SCENE, "step", GEMHOUSE_STEP_FIRSTTIME)
	if gemHouseStep!=GEMHOUSE_STEP_FIRSTTIME:
		var done=gemHouseStep==GEMHOUSE_STEP_DONE
		var count=NB_GORMONSTAR if done else min(NB_GORMONSTAR, GlobalPlayer.countItem(GlobalItems.ID.GORDMON_STAR))
		var star=GlobalItems.getItem(GlobalItems.ID.GORDMON_STAR)
		var text=GlobalGame.getTraductionById(GlobalGame.TRAD_GOALS_STARS) % [count, NB_GORMONSTAR]
		rows.add_child(_makeGoalRow(star.getTexture(), text, done))

# objectif "une epee" : n'importe quelle arme compte. On affiche la derniere
# arme possedee (la plus forte), sinon l'epee en bois
func _getGoalWeaponId():
	var goalWeaponId=GlobalItems.ID.WOOD_SWORD
	for weaponId in GlobalItems.getWeaponIdList():
		if GlobalPlayer.hasItem(weaponId):
			goalWeaponId=weaponId
	return goalWeaponId

# icone de l'objet (estompee s'il manque) et texte (vert une fois obtenu)
func _makeGoalRow(texture_, text_, done_):
	var row=HBoxContainer.new()
	row.add_theme_constant_override("separation", 4)
	var icon=TextureRect.new()
	icon.texture=texture_
	icon.custom_minimum_size=Vector2(16, 16)
	icon.expand_mode=TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode=TextureRect.STRETCH_KEEP_CENTERED
	if !done_:
		icon.modulate.a=GOAL_MISSING_ALPHA
	row.add_child(icon)
	var label=Label.new()
	label.theme_type_variation=&"DarkLabel"
	label.text=text_
	label.size_flags_vertical=Control.SIZE_SHRINK_CENTER
	if done_:
		label.add_theme_color_override("font_color", GOAL_DONE_COLOR)
	row.add_child(label)
	return row


#--- equipement

# objets qu'on peut tenir en main, dans l'ordre de l'inventaire
func getEquipableList():
	var equipableList=[]
	for itemId in GlobalPlayer.getItemsList():
		var type=GlobalItems.getItem(itemId).type
		if (type==item_class.TYPE.WEAPON or type==item_class.TYPE.TOOL) and !equipableList.has(int(itemId)):
			equipableList.append(int(itemId))
	return equipableList

# emplacement a cote de la barre : objet en main, a toucher pour changer
func refreshEquipment():
	var button=$Control/btnEquipment
	button.visible=!getEquipableList().is_empty()
	var icon=button.get_node("icon")
	icon.texture=GlobalItems.getItem(GlobalPlayer.getEquipment()).getTexture() if GlobalPlayer.hasEquipment() else null

func switchEquipment():
	# pas de changement d'objet en plein dialogue
	if GlobalGame.isDialogOpen():
		return
	var equipableList=getEquipableList()
	if equipableList.is_empty():
		return
	var index=-1
	if GlobalPlayer.hasEquipment():
		index=equipableList.find(int(GlobalPlayer.getEquipment()))
	var next=equipableList[(index+1)%equipableList.size()]
	if GlobalPlayer.hasEquipment() and next==int(GlobalPlayer.getEquipment()):
		return
	GlobalPlayer.setEquipment(next)
	Sfx.play(Sfx.CURSOR)
	emit_signal("equipItem",next)
	refreshEquipment()
