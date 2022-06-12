extends Node2D


var vitesse=50
var hasAlreadyWon=false

func getPlayer():
	return $character

# Called when the node enters the scene tree for the first time.
func _ready():
	
	hasAlreadyWon=GlobalScenes.getParamForSceneOr(filename,"hasAlreadyWon",false)
	
	if true==hasAlreadyWon:
		$ColorStart/simpleDialogStart.addDiscussion("Presentateur",[
					"Re-bonjour,",
					"Désolé, mais vous avez déjà gagné",
					])
		$ColorStart.visible=true
		$ColorStart/simpleDialogStart.start()
		
	else:
		getPlayer().loadCameraLimits($cameraRef)
	
		$navigation.disable()
		
		$ColorWin.visible=false
		$ColorWin/simpleDialogWin.addDiscussion("Presentateur",[
						"Félicitations, tu remporte ce jeu",
						"Voici 2 Gems de récompense"
						])
		
		$ColorStart.visible=true
		$ColorStart/simpleDialogStart.addDiscussion("Presentateur",[
			"Dans cet énigme,",
			"Vous devez placer les coquillages",
			"Sur les emplacements avec des croix"
		])
		$ColorStart/simpleDialogStart.start()

func _on_placeholder_placed(item_):
	item_.setPlaced(true)
	
	checkGame()

	
	
func checkGame():
	var seashellList=[$"sea-shell",$"sea-shell2",$"sea-shell3",$"sea-shell4",$"sea-shell5",$"sea-shell6"]

	var placedCount=0
	for seashell in seashellList:
		if seashell.getPlaced():
			placedCount+=1
	if placedCount == 6 :
		win()
	else:
		print("game over:"+str(placedCount))


func win():
	GlobalScenes.saveParamForScene(filename,"hasAlreadyWon",true)
	
	$ColorWin.visible=true
	$ColorWin/simpleDialogWin.start()
	$navigation.disable()
	$character.disableCamera()
	$Camera2D.current=true

func _on_placeholder7_unPlaced(item_):
	item_.setPlaced(false)

	checkGame()



func _on_simpleDialogStart_discussionFinished():
	if true==hasAlreadyWon:
		exitToVillage()	
	else:
		$ColorStart/simpleDialogStart.end()
		$ColorStart.visible=false
		$character.enableCamera()
		$navigation.enable()



func _on_simpleDialogWin_discussionFinished():
	$ColorWin/simpleDialogWin.end()
	GlobalPlayer.addGems(2)
	exitToVillage()


func _on_exit_body_shape_entered(body_id, body, body_shape, area_shape):
	if(body.is_in_group("Character")):
		exitToVillage()

func exitToVillage():
	GlobalPlayer.savePosition(Vector2(712,250))
	get_tree().change_scene("res://screens/crabs-village.tscn")
