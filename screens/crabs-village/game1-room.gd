extends Node2D

enum item{ ALGAE,ASTONISHED,CRAB,RAFT}

const OK="ok"
const CRAB_ATE_ASTONISHED="crab_ate_astonished"
const ASTONISHED_ATE_ALGAE="astonished_ate_algae"

var itemSelected=null

var itemOnRaft=null

var itemCurrentlyOnRaf=null

var hasAlreadyWon=false

func _ready():
	
	hasAlreadyWon=GlobalScenes.getParamForSceneOr(filename,"hasAlreadyWon",false)
	
	if true==hasAlreadyWon:
		$ColorStart/simpleDialogStart.addDiscussion(GlobalGame.getTraductionById(GlobalGame.TRAD_WORD_PRESENTATEUR),  GlobalGame.getTraductionById(GlobalGame.TRAD_CRABVILLAGE_GAME1_ALREADYWON)  )
		$ColorStart.visible=true
		$ColorStart/simpleDialogStart.start()
		
	else:
		
		resetGame()
		
		$ColorStart/simpleDialogStart.addDiscussion(GlobalGame.getTraductionById(GlobalGame.TRAD_WORD_PRESENTATEUR),GlobalGame.getTraductionById(GlobalGame.TRAD_CRABVILLAGE_GAME1_START)  )
						
		$ColorStart.visible=true
		$ColorStart/simpleDialogStart.start()
		
		$ColorWin.visible=false
		$ColorWin/simpleDialogWin.addDiscussion(GlobalGame.getTraductionById(GlobalGame.TRAD_WORD_PRESENTATEUR),GlobalGame.getTraductionById(GlobalGame.TRAD_CRABVILLAGE_GAME1_WIN)  )
	
func win():
	GlobalScenes.saveParamForScene(filename,"hasAlreadyWon",true)
	
	$ColorWin.visible=true
	$ColorWin/simpleDialogWin.start()

func resetGame():
	itemSelected=null
	itemOnRaft=null
	itemCurrentlyOnRaf=null
	
	$crabRight.visible=false
	$astonishedRight.visible=false
	$algaeRight.visible=false
	
	$crab.visible=true
	$astonished.visible=true
	$algae.visible=true
	
	$colorGameOver/crabAteAstonished.visible=false
	$colorGameOver/crabAteAstonished.frame=0
	$colorGameOver/astonishedAteAlgae.visible=false
	$colorGameOver/astonishedAteAlgae.frame=0
	resetRaft()
	unselectAll()
	

func checkGame():
	for itemLoop in [item.CRAB,item.ASTONISHED,item.ALGAE]:
		if getItemRight(itemLoop).visible==false:
			return
	win()

func checkGameLeft():
	var checkOnLeft=checkProblemForCrabAstonishedAndAlgaeOnSide(getItemLeft(item.CRAB),getItemLeft(item.ASTONISHED),getItemLeft(item.ALGAE))
	
	if OK!=checkOnLeft:
		gameOver(checkOnLeft)
	
	checkGame()
	
func checkGameRight():
	var checkOnRight=checkProblemForCrabAstonishedAndAlgaeOnSide(getItemRight(item.CRAB),getItemRight(item.ASTONISHED),getItemRight(item.ALGAE))
	
	if OK!=checkOnRight:
		gameOver(checkOnRight)

	checkGame()	

func checkProblemForCrabAstonishedAndAlgaeOnSide(crab_,astonished_,algae_):
	if crab_.visible and astonished_.visible and !algae_.visible:
		return CRAB_ATE_ASTONISHED
	if !crab_.visible and astonished_.visible and algae_.visible:
		return ASTONISHED_ATE_ALGAE
	return OK

func gameOver(state_):
	print( "game over:"+state_)
	if state_==CRAB_ATE_ASTONISHED:
		$colorGameOver.visible=true
		$colorGameOver/crabAteAstonished.visible=true
		$colorGameOver/crabAteAstonished.play()
	elif state_==ASTONISHED_ATE_ALGAE:
		$colorGameOver.visible=true
		$colorGameOver/astonishedAteAlgae.visible=true
		$colorGameOver/astonishedAteAlgae.play()

func moveItemFromRaftToLeft():
	if itemOnRaft==null:
		return
	getItemLeft(itemOnRaft).visible=true
	resetRaft()

func moveItemFromRaftToRight():
	if itemOnRaft==null:
		return
	if itemOnRaft!=null:
		getItemRight(itemOnRaft).visible=true
		resetRaft()

func moveItemOnRaft(id_):
	if itemOnRaft!=null:
		return
	
	getItemLeft(id_).visible=false
	getItemRight(id_).visible=false
	
	$raft.setItem(id_)
	itemOnRaft=id_
	
func resetRaft():
	$raft.setItem(null)
	itemOnRaft=null

func getItemLeft(id_):
	if id_==item.ALGAE:
		return $algae
	elif id_==item.ASTONISHED:
		return $astonished
	elif id_==item.CRAB:
		return $crab
	elif id_==item.RAFT:
		return $raft


func getItemRight(id_):
	if id_==item.ALGAE:
		return $algaeRight
	elif id_==item.ASTONISHED:
		return $astonishedRight
	elif id_==item.CRAB:
		return $crabRight
	elif id_==item.RAFT:
		return $raft



func unselectAll():
	itemSelected=null
	for id in [item.CRAB,item.ALGAE,item.ASTONISHED]:
		getItemLeft(id).setSelected(false)
		getItemRight(id).setSelected(false)
				
func selectItemLeft(item_):
	if $AnimationPlayer.is_playing():
		return
	if false==raftIsOnLeft():
		return
	unselectAll()
	itemSelected=item_
	getItemLeft(item_).setSelected(true)

func selectItemRight(item_):
	if $AnimationPlayer.is_playing():
		return
	if true==raftIsOnLeft():
		return
	unselectAll()
	itemSelected=item_
	getItemRight(item_).setSelected(true)
	

func _on_algae_selected():
	selectItemLeft(item.ALGAE)


func _on_astonished_selected():
	selectItemLeft(item.ASTONISHED)


func _on_crab_selected():
	selectItemLeft(item.CRAB)


func _on_raft_selected():
	if $AnimationPlayer.is_playing():
		return
	if itemOnRaft!=null:
		return
	if itemSelected!=null:
		moveItemOnRaft(itemSelected)


func _on_raft_goLeft():
	unselectAll()
	$AnimationPlayer.play_backwards("New Anim")

func _on_raft_goRight():
	unselectAll()
	$AnimationPlayer.play("New Anim")

func raftIsOnLeft():
	if $raft.global_position.x < 150:
		return true
	return false

func _on_AnimationPlayer_animation_finished(anim_name):
	if raftIsOnLeft():
		moveItemFromRaftToLeft()
		checkGameRight()
	else:
		moveItemFromRaftToRight()
		checkGameLeft()
	


func _on_crabRight_selected():
	selectItemRight(item.CRAB)

func _on_astonishedRight_selected():
	selectItemRight(item.ASTONISHED)

func _on_algaeRight_selected():
	selectItemRight(item.ALGAE)


func _on_crabAteAstonished_animation_finished():
	$colorGameOver/crabAteAstonished.stop()
	$colorGameOver/crabAteAstonished.frame=$colorGameOver/crabAteAstonished.frames.get_frame_count("default")
	



func _on_restart_button_down():
	$colorGameOver.visible=false
	resetGame()



func _on_astonishedAteAlgae_animation_finished():
	$colorGameOver/astonishedAteAlgae.stop()
	$colorGameOver/astonishedAteAlgae.frame=$colorGameOver/astonishedAteAlgae.frames.get_frame_count("default")


func _on_simpleDialogStart_discussionFinished():
	if true==hasAlreadyWon:
		exitToVillage()	
	else:
		$ColorStart/simpleDialogStart.end()
		$ColorStart.visible=false


func _on_simpleDialogWin_discussionFinished():
	GlobalPlayer.addGems(2)
	exitToVillage()	

func exitToVillage():
	GlobalPlayer.savePosition(Vector2(310, 193))
	get_tree().change_scene("res://screens/crabs-village.tscn")
