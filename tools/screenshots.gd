extends SceneTree
# Génère les captures d'écran de présentation (export/linux/screenshots) :
# chaque capture charge une scène du jeu avec un état de partie préparé,
# déclenche si besoin un dialogue ou le magasin, puis enregistre l'image.
# Lancé par generate_screenshots.sh (fenêtre visible : il faut le rendu).
#
# Variables d'environnement :
# - SHOTS_DIR : dossier de sortie
# - LANG_GAME : FR ou EN

const WAIT_SCENE=1.2
const WAIT_DIALOG=0.6
# taille des images (le jeu est rendu en 1280x720, agrandi sans lissage)
const SHOT_SIZE=Vector2i(1920,1080)

var _shotsDir=OS.get_environment("SHOTS_DIR")
var _lang=OS.get_environment("LANG_GAME")

# Les autoloads ne sont pas visibles à la compilation d'un script lancé par -s
var GlobalPlayer
var GlobalGame
var GlobalItems

func _initialize():
	GlobalPlayer=root.get_node("GlobalPlayer")
	GlobalGame=root.get_node("GlobalGame")
	GlobalItems=root.get_node("GlobalItems")
	_run.call_deferred()

func _run():
	GlobalGame.setLang(GlobalGame.FR if _lang=="FR" else GlobalGame.EN)
	GlobalPlayer.setNickname("Gordon")
	# texte des dialogues affiché d'un coup, pas de commandes tactiles
	GlobalPlayer.disableDialogAnimation()
	GlobalPlayer.disableTouch()

	# 01 : à la maison, Maman parle à Gordon
	await _open("res://screens/tree-village/gordon-home.tscn", Vector2(40,58))
	current_scene._on_mom_talk()
	await _shot(1, WAIT_DIALOG)

	# 02 : le marchand et ses produits
	await _open("res://screens/tree-village/shop.tscn", Vector2(110,70))
	current_scene._on_simpleDialog_discussionFinished()
	await _shot(2, WAIT_DIALOG)

	# 03 : le village dans les arbres
	await _open("res://screens/tree-village.tscn", Vector2(436,160))
	await _shot(3)

	# 04 : le puits cassé et l'artisan
	await _open("res://screens/tree-village.tscn", Vector2(960,180))
	current_scene._on_well_talk()
	await _shot(4, WAIT_DIALOG)

	# Gordon s'équipe d'une épée pour la suite de l'aventure
	GlobalPlayer.addItem(GlobalItems.ID.WOOD_SWORD)
	GlobalPlayer.addItem(GlobalItems.ID.HEALTH_POTION_10)
	GlobalPlayer.setEquipment(GlobalItems.ID.WOOD_SWORD)
	GlobalPlayer.addGems(6)

	# 05 : la forêt, devant le panneau des araignées
	await _open("res://screens/macro-map.tscn", Vector2(382,430))
	await _shot(5)

	# 06 : combat contre une araignée, au moment de choisir l'action
	GlobalPlayer.setSide("DOWN")
	await _open("res://screens/macro-map/spiderFight.tscn", Vector2(346,372))
	await _shot(6, 1.0)

	# 07 : sur la route du village des crabes (hors de la zone de sa porte)
	GlobalPlayer.setLife(80)
	GlobalPlayer.addXp(3)
	await _open("res://screens/macro-map.tscn", Vector2(470,240))
	await _shot(7)

	# 08 : le village des crabes et son habitant
	await _open("res://screens/crabs-village.tscn", Vector2(117,165))
	current_scene._on_welcomeboy_talk()
	await _shot(8, WAIT_DIALOG)

	# libère la scène avant de quitter (sinon Godot signale des fuites)
	unload_current_scene()
	await process_frame
	await process_frame
	quit()

# Charge la scène avec Gordon à la position donnée (lue par loadPosition)
func _open(path_, position_):
	GlobalPlayer.savePosition(position_)
	change_scene_to_file(path_)
	await scene_changed
	await _wait(WAIT_SCENE)

func _shot(number_, delay_=0.0):
	if delay_ > 0.0:
		await _wait(delay_)
	await process_frame
	var path="%s/Screenshot_%02d.png" % [_shotsDir, number_]
	var image=root.get_texture().get_image()
	image.resize(SHOT_SIZE.x, SHOT_SIZE.y, Image.INTERPOLATE_NEAREST)
	image.save_png(path)
	print(path)

func _wait(seconds_):
	await create_timer(seconds_).timeout
