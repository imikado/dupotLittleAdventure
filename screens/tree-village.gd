extends "res://common/class/scene.gd"

var groundFounded=null


func debug():
	GlobalPlayer.addItem(GlobalItems.ID.NAILS)
	GlobalPlayer.addItem(GlobalItems.ID.HONEY)
	GlobalPlayer.addItem(GlobalItems.ID.BUCKET)
	GlobalPlayer.addItem(GlobalItems.ID.GORMON_STAR_MAP)
	GlobalPlayer.addItem(GlobalItems.ID.SPADE)
	
	#$YSort/well.repair()
	#$YSort/craftsman.visible=false

	GlobalPlayer.setLife(80)
	getPlayer().reloadLife()

	GlobalPlayer.addItem(GlobalItems.ID.HEALTH_POTION_10)

func _ready():
	
	setPlayerPath("YSort/playerAndControl")
	loadPosition()
	getPlayer().loadCameraLimits($cameraRef)



	var TRAD_ARTISAN=GlobalGame.getTraductionById(GlobalGame.TRAD_WORD_ARTISAN)

	#debug()

	if true==GlobalScenes.getParamForSceneOr(filename,'ground.isDiscovered',false):
		$ground.enableDiscovered()
	
	if true==GlobalScenes.getParamForSceneOr(filename,'ground2.isDiscovered',false):
		$ground2.enableDiscovered()
	
	if true==GlobalScenes.getParamForSceneOr(filename,'ground3.isDiscovered',false):
		$ground3.enableDiscovered()
	
	if true==GlobalScenes.getParamForSceneOr(filename,'ground4.isDiscovered',false):
		$ground4.enableDiscovered()
	
	if true==GlobalScenes.getParamForSceneOr(filename,'ground5.isDiscovered',false):
		$ground5.enableDiscovered()
	
	if GlobalPlayer.hasItem(GlobalItems.ID.NAILS) and GlobalPlayer.hasItem(GlobalItems.ID.HONEY) and GlobalPlayer.hasItem(GlobalItems.ID.BUCKET) :
		
		var discussionList=GlobalGame.getTraductionById(GlobalGame.TRAD_TREEVILLAGE_START)

		$simpleDialog.addDiscussion(TRAD_ARTISAN,discussionList[0])
		$simpleDialog.addDiscussion("Gordon",discussionList[1])
		$simpleDialog.addDiscussion(TRAD_ARTISAN,discussionList[2])
	
	elif GlobalPlayer.hasItem(GlobalItems.ID.NAILS) or GlobalPlayer.hasItem(GlobalItems.ID.HONEY) or GlobalPlayer.hasItem(GlobalItems.ID.BUCKET) :

		var discussionList=GlobalGame.getTraductionById(GlobalGame.TRAD_TREEVILLAGE_PENDING)

		$simpleDialog.addDiscussion(TRAD_ARTISAN,discussionList[0])
		$simpleDialog.addDiscussion("Gordon",discussionList[1])

		var missingItem=[]
		if !GlobalPlayer.hasItem(GlobalItems.ID.NAILS):
			missingItem.append(discussionList[2])
		if !GlobalPlayer.hasItem(GlobalItems.ID.HONEY):
			missingItem.append(discussionList[3])
		if !GlobalPlayer.hasItem(GlobalItems.ID.BUCKET):
			missingItem.append(discussionList[4])
					
		$simpleDialog.addDiscussion("Gordon",missingItem)

	else:

		var discussionList=GlobalGame.getTraductionById(GlobalGame.TRAD_TREEVILLAGE_START)
		
		$simpleDialog.addDiscussion(TRAD_ARTISAN,discussionList[0])
		$simpleDialog.addDiscussion("Gordon",discussionList[1])
		$simpleDialog.addDiscussion(TRAD_ARTISAN,discussionList[2])
		$simpleDialog.addDiscussion("Gordon",discussionList[3])
		$simpleDialog.addDiscussion(TRAD_ARTISAN,discussionList[4])
	
	

func _on_shop_playerEntered():
	GlobalPlayer.savePosition(Vector2(48,73))
	get_tree().change_scene("res://screens/tree-village/shop.tscn")


func _on_gordonhome_playerEntered():
	GlobalPlayer.savePosition(Vector2(55,84))
	get_tree().change_scene("res://screens/tree-village/gordon-home.tscn")

func _on_gemhouse_playerEntered():
	GlobalPlayer.savePosition(Vector2(48,73))
	get_tree().change_scene("res://screens/tree-village/gem-house.tscn")
	pass # Replace with function body.


func _on_goOutFromTreeVillage_playerOpenedDoor():
	GlobalPlayer.savePosition(Vector2(293,608))
	get_tree().change_scene("res://screens/macro-map.tscn")
	pass # Replace with function body.




func _on_playerAndControl_endClimbing():
	$YSort.sort_enabled=true



func _on_playerAndControl_startClimbing():
	$YSort.sort_enabled=false

 


func _on_playerAndControl_digging():
	if groundFounded!=null:
		groundFounded.play()
		print("play ground")
	pass # Replace with function body.

func _on_playerAndControl_endDigging():
	if groundFounded!=null:
		groundFounded.stop()
	pass # Replace with function body.

#--- grounds
func processGormonStarFounded(grounded_):
	$notification.display(GlobalGame.getTraductionById(GlobalGame.TRAD_TREEVILLAGE_STARFOUND))
	GlobalPlayer.addItemEvenIfExist(GlobalItems.ID.GORDMON_STAR)
	$YSort/playerAndControl.reloadInvetory()
	
	GlobalScenes.saveParamForScene(filename,grounded_+".isDiscovered",true)
	
	get_node(grounded_).queue_free()
	

func processGroundedLeft():
	groundFounded.stop()
	groundFounded=null

#ground
func _on_ground_isDiscovered():
	processGormonStarFounded("ground")
	
func _on_ground_rightGroundFounded():
	groundFounded=$ground

func _on_ground_rightGroundFoundedLeft():
	processGroundedLeft()

#ground2
func _on_ground2_isDiscovered():
	processGormonStarFounded("ground2")

func _on_ground2_rightGroundFounded():
	groundFounded=$ground2

func _on_ground2_rightGroundFoundedLeft():
	processGroundedLeft()

#ground3
func _on_ground3_isDiscovered():
	processGormonStarFounded("ground3")

func _on_ground3_rightGroundFounded():
	groundFounded=$ground3

func _on_ground3_rightGroundFoundedLeft():
	processGroundedLeft()

#ground4
func _on_ground4_isDiscovered():
	processGormonStarFounded("ground4")

func _on_ground4_rightGroundFounded():
	groundFounded=$ground4

func _on_ground4_rightGroundFoundedLeft():
	processGroundedLeft()

#ground5
func _on_ground5_isDiscovered():
	processGormonStarFounded("ground5")

func _on_ground5_rightGroundFounded():
	groundFounded=$ground5

func _on_ground5_rightGroundFoundedLeft():
	processGroundedLeft()


#func _on_craftsman_talk():
	#$simpleDialog.start()
	#getPlayer().disableNavigation()
	

func _on_simpleDialog_discussionFinished():
	$simpleDialog.end()
	getPlayer().enableNavigation()

	if GlobalPlayer.hasItem(GlobalItems.ID.NAILS) and GlobalPlayer.hasItem(GlobalItems.ID.HONEY) and GlobalPlayer.hasItem(GlobalItems.ID.BUCKET) :
		$YSort/well.repair()



func _on_well_talk():
	$simpleDialog.start()
	getPlayer().disableNavigation()


func _on_well_repaired():
	$endgame.visible=true
	#get_tree().change_scene("res://screens/game/endgame.tscn")
	pass # Replace with function body.


func _on_gotBackToMenu_button_down():
	get_tree().change_scene("res://screens/game/menu.tscn")
