extends "res://common/class/scene.gd"

var shopItemClass=preload("res://common/class/shopItem_class.gd")

const STEP_FIRSTTIME='first_time'
const STEP_SHOULD_FIND_GORMONSTAR='shouldFindGormonStar'
const STEP_HAS_FOUND_GORMONSTAR='hasFoundGormonStar'

func _ready():
	setPlayerPath("playerAndControl")
	loadPosition()
	getPlayer().zoomDown()
	getPlayer().loadCameraLimits($cameraRef)

	var TRAD_VENDEUR=GlobalGame.getTraductionById(GlobalGame.TRAD_WORD_VENDEUR)

	var step=GlobalScenes.getParamForSceneOr(filename,"step",STEP_FIRSTTIME)

	if step==STEP_FIRSTTIME :

		var discussionList=GlobalGame.getTraductionById(GlobalGame.TRAD_TREEVILLAGE_GEMHOUSE_START)

		$simpleDialog.addDiscussion(TRAD_VENDEUR,discussionList[0])
		$simpleDialog.addDiscussion("Gordon",discussionList[1])
		$simpleDialog.addDiscussion(TRAD_VENDEUR,discussionList[2])
		$simpleDialog.addDiscussion("Gordon",discussionList[3])
		$simpleDialog.addDiscussion(TRAD_VENDEUR,discussionList[4])
		$simpleDialog.addDiscussion("Gordon",discussionList[5])
			
		GlobalScenes.saveParamForScene(filename,"step",STEP_SHOULD_FIND_GORMONSTAR)

	elif step==STEP_SHOULD_FIND_GORMONSTAR:
		
		var discussionList=GlobalGame.getTraductionById(GlobalGame.TRAD_TREEVILLAGE_GEMHOUSE_PENDING)

		$simpleDialog.addDiscussion(TRAD_VENDEUR,discussionList[0])

		var nbGormonStarFounded=GlobalPlayer.countItem(GlobalItems.ID.GORDMON_STAR)
		
		if nbGormonStarFounded < 5:
			$simpleDialog.addDiscussion("Gordon",discussionList[1])
		elif nbGormonStarFounded == 5:
			$simpleDialog.addDiscussion("Gordon",discussionList[2])
			$simpleDialog.addDiscussion(TRAD_VENDEUR,discussionList[3])

			GlobalPlayer.addGems(10)
			for i in range(5):
				GlobalPlayer.removeItem(GlobalItems.ID.GORDMON_STAR)
				
				GlobalScenes.saveParamForScene(filename,"step",STEP_HAS_FOUND_GORMONSTAR)
				
			getPlayer().reloadGems()
	
	elif step==STEP_HAS_FOUND_GORMONSTAR:
		var discussionList=GlobalGame.getTraductionById(GlobalGame.TRAD_TREEVILLAGE_GEMHOUSE_END)
		$simpleDialog.addDiscussion(TRAD_VENDEUR,discussionList[0])
	
	#debug
	
func _on_door_playerOpenedDoor():
	GlobalPlayer.savePosition(Vector2(651,115))
	get_tree().change_scene("res://screens/tree-village.tscn")


func _on_discussionDoor_playerOpenedDoor():
	$simpleDialog.start()
	pass # Replace with function body.

func giveToPlayerSpadeAndMap():
	GlobalPlayer.addItem(GlobalItems.ID.SPADE)
	GlobalPlayer.addItem(GlobalItems.ID.GORMON_STAR_MAP)

func _on_simpleDialog_discussionFinished():
	$simpleDialog.end()
	
	giveToPlayerSpadeAndMap()
	getPlayer().enableNavigation()

func _on_discussionArea_playerOpenedDoor():
	$simpleDialog.start()
	getPlayer().disableNavigation()
