extends Node2D

const DefaultTheme=preload("res://common/themes/default.tres")

# un coquillage est pose quand son centre est sur une croix (case de 32x32)
const TARGET_HALF_SIZE=16
# la zone de la croix est decalee vers le bas dans placeholder.tscn
const TARGET_OFFSET=Vector2(0,8)
const RESET_MARGIN=4

var vitesse=50
var hasAlreadyWon=false
var gameWon=false

# positions de depart, pour recommencer sans recharger la salle
var startPositions={}

@onready var seashellList=[$"sea-shell",$"sea-shell2",$"sea-shell3",$"sea-shell4",$"sea-shell5",$"sea-shell6"]
@onready var targetList=[$placeholder,$placeholder2,$placeholder3,$placeholder4,$placeholder5,$placeholder6]

var resetButton:Button

func getPlayer():
	return $character

# Called when the node enters the scene tree for the first time.
func _ready():

	hasAlreadyWon=GlobalScenes.getParamForSceneOr(scene_file_path,"hasAlreadyWon",false)

	if true==hasAlreadyWon:
		$ColorStart/simpleDialogStart.addDiscussion(GlobalGame.getTraductionById(GlobalGame.TRAD_WORD_PRESENTATEUR),GlobalGame.getTraductionById(GlobalGame.TRAD_CRABVILLAGE_GAME1_ALREADYWON))
		$ColorStart.visible=true
		$ColorStart/simpleDialogStart.start()

	else:
		getPlayer().loadCameraLimits($cameraRef)

		$navigation.disable()

		$ColorWin.visible=false
		$ColorWin/simpleDialogWin.addDiscussion(GlobalGame.getTraductionById(GlobalGame.TRAD_WORD_PRESENTATEUR),GlobalGame.getTraductionById(GlobalGame.TRAD_CRABVILLAGE_GAME1_WIN))

		$ColorStart.visible=true
		$ColorStart/simpleDialogStart.addDiscussion(GlobalGame.getTraductionById(GlobalGame.TRAD_WORD_PRESENTATEUR),GlobalGame.getTraductionById(GlobalGame.TRAD_CRABVILLAGE_GAME3_START))
		$ColorStart/simpleDialogStart.start()

	for node in seashellList+[getPlayer()]:
		startPositions[node]=node.position
	_buildResetButton()

# bouton "Recommencer" en haut a droite (touche R ou bouton Y de la manette)
func _buildResetButton():
	var layer=CanvasLayer.new()
	add_child(layer)
	resetButton=Button.new()
	resetButton.theme=DefaultTheme
	resetButton.theme_type_variation=&"ChipButton"
	resetButton.text=GlobalGame.getTraductionById(GlobalGame.TRAD_UI_RESET)
	resetButton.focus_mode=Control.FOCUS_NONE
	resetButton.visible=false
	resetButton.pressed.connect(resetGame)
	layer.add_child(resetButton)
	resetButton.reset_size()
	resetButton.position=Vector2(get_viewport_rect().size.x-resetButton.size.x-RESET_MARGIN, RESET_MARGIN)

func _unhandled_input(event):
	if !resetButton.visible:
		return
	var pressed=(event is InputEventKey and event.pressed and !event.echo and event.keycode==KEY_R) or (event is InputEventJoypadButton and event.pressed and event.button_index==JOY_BUTTON_Y)
	if pressed:
		resetGame()
		get_viewport().set_input_as_handled()

func resetGame():
	Sfx.play(Sfx.CANCEL)
	for node in startPositions:
		node.position=startPositions[node]
	checkGame()

func _physics_process(delta):
	if !gameWon and !hasAlreadyWon:
		checkGame()

func isOnTarget(seashell_, usedTargetList_):
	for target in targetList:
		if usedTargetList_.has(target):
			continue
		var gap=seashell_.global_position-(target.global_position+TARGET_OFFSET)
		if abs(gap.x) < TARGET_HALF_SIZE and abs(gap.y) < TARGET_HALF_SIZE:
			usedTargetList_.append(target)
			return true
	return false

func checkGame():
	var usedTargetList=[]
	var placedCount=0
	for seashell in seashellList:
		seashell.setPlaced(isOnTarget(seashell, usedTargetList))
		if seashell.getPlaced():
			placedCount+=1
	if placedCount == seashellList.size():
		win()


func win():
	gameWon=true
	resetButton.visible=false
	GlobalScenes.saveParamForScene(scene_file_path,"hasAlreadyWon",true)

	$ColorWin.visible=true
	$ColorWin/simpleDialogWin.start()
	$navigation.disable()
	$character.disableCamera()
	$Camera2D.enabled=true
	$Camera2D.make_current()


func _on_simpleDialogStart_discussionFinished():
	if true==hasAlreadyWon:
		exitToVillage()
	else:
		$ColorStart/simpleDialogStart.end()
		$ColorStart.visible=false
		$character.enableCamera()
		$navigation.enable()
		resetButton.visible=true



func _on_simpleDialogWin_discussionFinished():
	$ColorWin/simpleDialogWin.end()
	GlobalPlayer.addGems(2)
	exitToVillage()


func _on_exit_body_shape_entered(body_id, body, body_shape, area_shape):
	if(body.is_in_group("Character")):
		exitToVillage()

func exitToVillage():
	GlobalPlayer.savePosition(Vector2(712,250))
	SceneTransition.change_scene("res://screens/crabs-village.tscn")
