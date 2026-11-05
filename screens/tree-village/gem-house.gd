extends "res://common/class/scene.gd"

var shopItemClass=preload("res://common/class/shopItem_class.gd")

const STEP_FIRSTTIME='first_time'
const STEP_SHOULD_FIND_GORMONSTAR='shouldFindGormonStar'
const STEP_HAS_FOUND_GORMONSTAR='hasFoundGormonStar'

const NB_GORMONSTAR=5
const GEMS_PER_GORMONSTAR=2

func _ready():
	setPlayerPath("playerAndControl")
	loadPosition()
	getPlayer().zoomDown()
	getPlayer().loadCameraLimits($cameraRef)

	buildDiscussion()

func getStep():
	return GlobalScenes.getParamForSceneOr(scene_file_path,"step",STEP_FIRSTTIME)

func hasAllGormonStars():
	return GlobalPlayer.countItem(GlobalItems.ID.GORDMON_STAR) >= NB_GORMONSTAR

# le dialogue depend de l'avancement : il est reconstruit apres chaque discussion
func buildDiscussion():
	$simpleDialog.clearDiscussion()

	var TRAD_VENDEUR=GlobalGame.getTraductionById(GlobalGame.TRAD_WORD_VENDEUR)
	var TRAD_GORDON=GlobalGame.getTraductionById(GlobalGame.TRAD_WORD_GORDON)

	var step=getStep()

	if step==STEP_FIRSTTIME :

		var discussionList=GlobalGame.getTraductionById(GlobalGame.TRAD_TREEVILLAGE_GEMHOUSE_START)

		$simpleDialog.addDiscussion(TRAD_VENDEUR,discussionList[0])
		$simpleDialog.addDiscussion(TRAD_GORDON,discussionList[1])
		$simpleDialog.addDiscussion(TRAD_VENDEUR,discussionList[2])
		$simpleDialog.addDiscussion(TRAD_GORDON,discussionList[3])
		$simpleDialog.addDiscussion(TRAD_VENDEUR,discussionList[4])
		$simpleDialog.addDiscussion(TRAD_GORDON,discussionList[5])

	elif step==STEP_SHOULD_FIND_GORMONSTAR:

		var discussionList=GlobalGame.getTraductionById(GlobalGame.TRAD_TREEVILLAGE_GEMHOUSE_PENDING)

		$simpleDialog.addDiscussion(TRAD_VENDEUR,discussionList[0])

		if hasAllGormonStars():
			$simpleDialog.addDiscussion(TRAD_GORDON,discussionList[2])
			$simpleDialog.addDiscussion(TRAD_VENDEUR,discussionList[3])
		else:
			$simpleDialog.addDiscussion(TRAD_GORDON,discussionList[1])

	elif step==STEP_HAS_FOUND_GORMONSTAR:
		var discussionList=GlobalGame.getTraductionById(GlobalGame.TRAD_TREEVILLAGE_GEMHOUSE_END)
		$simpleDialog.addDiscussion(TRAD_VENDEUR,discussionList[0])

func _on_door_playerOpenedDoor():
	GlobalPlayer.savePosition(Vector2(651,115))
	SceneTransition.change_scene("res://screens/tree-village.tscn")


func _on_discussionDoor_playerOpenedDoor():
	$simpleDialog.start()
	pass # Replace with function body.

func giveToPlayerSpadeAndMap():
	GlobalPlayer.addItem(GlobalItems.ID.SPADE)
	GlobalPlayer.addItem(GlobalItems.ID.GORMON_STAR_MAP)
	getPlayer().reloadInvetory()

func giveGemsForGormonStars():
	for i in range(NB_GORMONSTAR):
		GlobalPlayer.removeItem(GlobalItems.ID.GORDMON_STAR)
	GlobalPlayer.addGems(NB_GORMONSTAR*GEMS_PER_GORMONSTAR)
	getPlayer().reloadGems()
	getPlayer().reloadInvetory()

# la quete n'avance qu'une fois la discussion terminee
func _on_simpleDialog_discussionFinished():
	$simpleDialog.end()

	var step=getStep()
	if step==STEP_FIRSTTIME:
		giveToPlayerSpadeAndMap()
		GlobalScenes.saveParamForScene(scene_file_path,"step",STEP_SHOULD_FIND_GORMONSTAR)
	elif step==STEP_SHOULD_FIND_GORMONSTAR and !hasAllGormonStars():
		# anciennes sauvegardes : l'etape avancait avant d'avoir recu la pelle
		giveToPlayerSpadeAndMap()
	elif step==STEP_SHOULD_FIND_GORMONSTAR:
		giveGemsForGormonStars()
		GlobalScenes.saveParamForScene(scene_file_path,"step",STEP_HAS_FOUND_GORMONSTAR)

	buildDiscussion()
	getPlayer().enableNavigation()

func _on_discussionArea_playerOpenedDoor():
	$simpleDialog.start()
	getPlayer().disableNavigation()
