extends CanvasLayer

# Interface du combat : boite de message + menu d'actions navigable
# a la souris, au tactile, au clavier et a la manette

signal leave
signal attack(attack_)
signal usePotion

const attackClass=preload("res://common/class/item/attack_class.gd")
const PUNCH_DAMAGE=4

@onready var message=$messageBox/message
@onready var actions=$actions
@onready var buttonList=$actions/list

var potionItemId=GlobalItems.ID.HEALTH_POTION_10
var showingAttacks=false

func _ready():
	actions.visible=false

func _unhandled_input(event):
	# Echap / bouton retour : revient du choix d'attaque au menu principal
	if actions.visible and showingAttacks and event.is_action_pressed("ui_cancel"):
		showActions()
		get_viewport().set_input_as_handled()

func showMessage(text_):
	message.text=text_
	message.visible_ratio=0.0
	if !GlobalPlayer.isDialogAnimationEnabled():
		message.visible_ratio=1.0
		return
	var tween=message.create_tween()
	tween.tween_property(message, "visible_ratio", 1.0, 0.012*text_.length())

func hideWindow():
	actions.visible=false
	$messageBox.visible=true

func showWindow():
	showActions()

func showActions():
	showingAttacks=false
	$messageBox.visible=true
	_clear()
	var attackButton=_addButton(_trad(GlobalGame.TRAD_FIGHT_ATTACK), _on_attackButton_pressed)
	var potionCount=GlobalPlayer.countItem(potionItemId)
	var potionButton=_addButton(_trad(GlobalGame.TRAD_FIGHT_POTION) % potionCount, _on_potionButton_pressed)
	potionButton.disabled=potionCount==0 or GlobalPlayer.getLife() >= GlobalPlayer.getMaxLife()
	_addButton(_trad(GlobalGame.TRAD_FIGHT_FLEE), _on_leaveButton_pressed)
	_open(attackButton)

func showAttacks():
	showingAttacks=true
	# la liste des attaques est large : elle prend la place du message
	$messageBox.visible=false
	_clear()
	var first=null
	var weaponAttackList=GlobalPlayer.getWeaponAttackList()
	if weaponAttackList.is_empty():
		# sans arme, on se defend quand meme a mains nues
		weaponAttackList=[attackClass.new(_trad(GlobalGame.TRAD_FIGHT_PUNCH), "", PUNCH_DAMAGE, 0)]
	for attackLoop in weaponAttackList:
		var button
		if GlobalPlayer.isAttackUnlocked(attackLoop):
			button=_addButton(attackLoop.name+"  "+str(attackLoop.damage), _on_attack_pressed.bind(attackLoop))
			if first==null:
				first=button
		else:
			# attaque visible mais verrouillee : donne un objectif d'xp
			button=_addButton(attackLoop.name+"  XP "+str(attackLoop.xpMin), Callable())
			button.disabled=true
	_addButton(_trad(GlobalGame.TRAD_FIGHT_BACK), showActions)
	_open(first)

func _open(focus_):
	# le panneau reprend la taille de son contenu (il grandit vers le haut et la gauche)
	actions.offset_left=actions.offset_right
	actions.offset_top=actions.offset_bottom
	actions.visible=true
	# on attend que le conteneur ait pris sa taille avant de donner le focus
	await get_tree().process_frame
	if focus_!=null and is_instance_valid(focus_):
		focus_.grab_focus()

func _clear():
	for child in buttonList.get_children():
		buttonList.remove_child(child)
		child.queue_free()

func _addButton(text_, callable_:Callable):
	var button=Button.new()
	button.text=text_
	button.alignment=HORIZONTAL_ALIGNMENT_LEFT
	if callable_.is_valid():
		button.pressed.connect(callable_)
	buttonList.add_child(button)
	return button

func _trad(id_):
	return GlobalGame.getTraductionById(id_)

func _on_leaveButton_pressed():
	hideWindow()
	emit_signal("leave")

func _on_attackButton_pressed():
	showAttacks()

func _on_potionButton_pressed():
	hideWindow()
	emit_signal("usePotion")

func _on_attack_pressed(attack_):
	hideWindow()
	emit_signal("attack", attack_)
