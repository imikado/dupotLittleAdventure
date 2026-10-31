extends SceneTree
# Joue une courte démo du jeu pour le GIF de présentation, un passage par type
# de jeu : le titre, Maman, la sortie du village dans les arbres, la carte, un
# combat au tour par tour, le combat contre les abeilles, la plateforme de
# l'ours puis le village des crabes.
# Lancé par generate_gif.sh avec --write-movie : Godot enregistre chaque image
# à cadence fixe, ce script ne fait que piloter le jeu.
#
# Variables d'environnement :
# - LANG_GAME : FR ou EN

var _lang=OS.get_environment("LANG_GAME")

# Les autoloads ne sont pas visibles à la compilation d'un script lancé par -s
var GlobalPlayer
var GlobalGame
var GlobalItems
var GlobalScenes

const PLATFORM_SCENE="res://screens/bear-village/bee-village-platform.tscn"
const FIGHT_SCENE="res://screens/macro-map/spiderFight.tscn"
# l'intro du combat (apparition, astuce) défile en accéléré
const FIGHT_INTRO_SPEED=6.0

func _initialize():
	GlobalPlayer=root.get_node("GlobalPlayer")
	GlobalGame=root.get_node("GlobalGame")
	GlobalItems=root.get_node("GlobalItems")
	GlobalScenes=root.get_node("GlobalScenes")
	_run.call_deferred()

func _run():
	GlobalGame.setLang(GlobalGame.FR if _lang=="FR" else GlobalGame.EN)
	GlobalPlayer.setNickname("Gordon")
	GlobalPlayer.disableTouch()

	# l'écran titre
	change_scene_to_file("res://screens/game/title.tscn")
	await scene_changed
	await _wait(2.0)

	# à la maison, Maman parle à Gordon (texte qui s'écrit lettre par lettre)
	await _open("res://screens/tree-village/gordon-home.tscn", Vector2(40,58), 0.6)
	current_scene._on_mom_talk()
	await _wait(2.0)

	# Gordon part équipé de l'épée en bois (combats et guêpes)
	GlobalPlayer.addItem(GlobalItems.ID.WOOD_SWORD)
	GlobalPlayer.setEquipment(GlobalItems.ID.WOOD_SWORD)
	GlobalPlayer.addGems(6)

	# Gordon traverse le village et en sort : la transition mène à la carte
	await _open("res://screens/tree-village.tscn", Vector2(1230,232), 0.4)
	# il lâche la flèche dès que la porte lance la transition
	var transition=root.get_node("SceneTransition")
	Input.action_press("ui_right")
	while !transition.isBusy():
		await process_frame
	Input.action_release("ui_right")
	await _waitTransition()
	await _wait(0.3)

	# carte du monde : une étape vers la toile, puis la route du nord
	# passe par la toile et l'araignée attaque
	await _walk("ui_right", 0.3)
	await _waitArrival()
	await _wait(0.5)
	await _walk("ui_up", 0.2)
	while current_scene==null or current_scene.scene_file_path!=FIGHT_SCENE:
		await process_frame

	# combat au tour par tour : Gordon, équipé d'une épée, attaque l'araignée
	Engine.time_scale=FIGHT_INTRO_SPEED
	await _waitFocus()
	Engine.time_scale=1.0
	await _wait(0.5)
	# "Attaque", puis la première attaque de l'épée
	await _pressFocused()
	await _waitFocus()
	await _wait(0.4)
	await _pressFocused()
	# on part après les dégâts, sans attendre la riposte
	await _wait(2.0)

	# combat en temps réel : Gordon, l'épée en bois en main, fonce sur les
	# guêpes en donnant des coups (seule l'épée active la zone de frappe)
	GlobalPlayer.setEquipment(GlobalItems.ID.WOOD_SWORD)
	await _open("res://screens/bear-village/bevil-room-game.tscn", Vector2(150,0), 0.0)
	var gordon=current_scene.get_node("playerAndControl/player")
	# les guêpes ne le blessent pas (évite l'écran rouge et la vie qui fond)
	gordon.get_node("damage").set_deferred("monitoring", false)
	await _wait(0.3)
	Input.action_press("ui_right")
	for i in 6:
		# comme un appui sur le bouton : un "just pressed" simulé arriverait
		# une image trop tard pour le joueur
		gordon.buttonPressed=true
		await _wait(0.3)
		gordon.buttonPressed=false
		await _wait(0.1)
	Input.action_release("ui_right")
	await _wait(0.4)
	GlobalPlayer.setLife(GlobalPlayer.getMaxLife())

	# plateforme : l'ours court et saute (dialogue d'accueil déjà vu)
	GlobalScenes.saveParamForScene(PLATFORM_SCENE, "dialogStillDisplayed", true)
	change_scene_to_file(PLATFORM_SCENE)
	await scene_changed
	# commandes tactiles masquées
	current_scene.get_node("navigation").visible=false
	await _wait(0.3)
	await _runAndJump(current_scene.getPlayer(), 2.4)
	await _wait(0.3)

	# le village des crabes et son habitant
	await _open("res://screens/crabs-village.tscn", Vector2(117,165), 0.8)
	current_scene._on_welcomeboy_talk()
	await _wait(2.0)

	# libère la scène avant de quitter (sinon Godot signale des fuites)
	unload_current_scene()
	await process_frame
	await process_frame
	quit()

# Charge la scène avec Gordon à la position donnée (lue par loadPosition)
func _open(path_, position_, wait_):
	GlobalPlayer.savePosition(position_)
	change_scene_to_file(path_)
	await scene_changed
	await _wait(wait_)

# Maintient une direction comme si le joueur appuyait sur la touche
func _walk(action_, seconds_):
	Input.action_press(action_)
	await _wait(seconds_)
	Input.action_release(action_)

# Appui bref sur une touche (saut, coup d'épée)
func _press(action_, seconds_):
	Input.action_press(action_)
	await _wait(seconds_)
	Input.action_release(action_)

# Fait courir l'ours vers la droite : il saute dès qu'il n'y a plus de sol
# devant ses pieds (sinon il tombe et c'est Game Over)
const JUMP_LOOKAHEAD=14
const JUMP_PROBE_DEPTH=48
func _runAndJump(bear_:CharacterBody2D, seconds_):
	Input.action_press("ui_right")
	var frames=0
	while frames < seconds_*Engine.physics_ticks_per_second:
		await physics_frame
		frames+=1
		if !bear_.is_on_floor():
			continue
		var from=bear_.global_position+Vector2(JUMP_LOOKAHEAD, 0)
		var query=PhysicsRayQueryParameters2D.create(from, from+Vector2(0, JUMP_PROBE_DEPTH))
		query.exclude=[bear_.get_rid()]
		if bear_.get_world_2d().direct_space_state.intersect_ray(query).is_empty():
			# comme un appui sur le bouton de saut : un "just pressed" simulé
			# arriverait une image trop tard (ce signal suit la physique de l'ours)
			bear_.buttonPressed=true
	Input.action_release("ui_right")

# Attend que Gordon soit arrivé à l'étape suivante de la carte du monde
func _waitArrival():
	while !current_scene.route.is_empty():
		await process_frame

# Attend la fin du fondu lancé par une porte, s'il y en a un
func _waitTransition():
	var transition=root.get_node("SceneTransition")
	while transition.isBusy():
		await process_frame

# Attend qu'un bouton du menu de combat ait le focus
func _waitFocus():
	while root.gui_get_focus_owner()==null:
		await process_frame

func _pressFocused():
	var button=root.gui_get_focus_owner()
	root.gui_release_focus()
	if button is BaseButton:
		button.pressed.emit()
	await process_frame

func _wait(seconds_):
	if seconds_ > 0.0:
		await create_timer(seconds_).timeout
