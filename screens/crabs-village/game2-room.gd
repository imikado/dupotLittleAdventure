extends Node2D

const TWO_H="2H"
const TWO_V="2V"

const THREE_H="3H"
const THREE_V="3V"

	
var vitesse=(640*3)

var hasAlreadyWon=false

func _ready():
	
	hasAlreadyWon=GlobalScenes.getParamForSceneOr(filename,"hasAlreadyWon",false)
	
	if true==hasAlreadyWon:
		$simpleDialogStart.addDiscussion("Presentateur",[
					"Re-bonjour,",
					"Désolé, mais vous avez déjà gagné",
					])
		$ColorStart.visible=true
		$simpleDialogStart.start()
		
	else:

		$colorWin.visible=false
		$simpleDialogWin.addDiscussion("Presentateur",[
						"Félicitations, tu remporte ce jeu",
						"Voici 2 Gems de récompense"
						])
						
		$ColorStart.visible=true
		$simpleDialogStart.addDiscussion("Presentateur",[
						"Dans cet énigme,",
						"Vous devez faire sortir",
						"La barque avec le crabe"
			
		])
		$simpleDialogStart.start()
	

func win():
	GlobalScenes.saveParamForScene(filename,"hasAlreadyWon",true)

	$colorWin.visible=true
	$simpleDialogWin.start()

func moveLeft(item_):
	item_.move_and_slide(Vector2.LEFT*vitesse)
	#item_.position+=Vector2(-20,0)

func moveRight(item_):
	item_.move_and_slide(Vector2.RIGHT*vitesse)
	
	if "displayDriver" in item_:
		if item_.global_position.x > (32*8):
			win()
	
func moveUp(item_):
	item_.move_and_slide(Vector2.UP*vitesse)
	
func moveDown(item_):
	item_.move_and_slide(Vector2.DOWN*vitesse)


func _on_raft2horiz_goLeft(id_):
	moveLeft(id_)

func _on_raft2horiz_goRight(id_):
	moveRight(id_)

func _on_raft2vert_goDown(id_):
	moveDown(id_)

func _on_raft2vert_goUp(id_):
	moveUp(id_)


func _on_raft3horiz_goLeft(id_):
	moveLeft(id_)

func _on_raft3horiz_goRight(id_):
	moveRight(id_)
	
	


func _on_raft3vert_goDown(id_):
	moveDown(id_)


func _on_raft3vert_goUp(id_):
	moveUp(id_)


func _on_simpleDialog_discussionFinished():
	GlobalPlayer.addGems(2)
	exitToVillage()


func _on_simpleDialogStart_discussionFinished():
	if true==hasAlreadyWon:
		exitToVillage()	
	else:
		$ColorStart.visible=false
		$simpleDialogStart.end()
	
	
func exitToVillage():
	GlobalPlayer.savePosition(Vector2(497,231))
	get_tree().change_scene("res://screens/crabs-village.tscn")

