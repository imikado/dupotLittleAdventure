extends CanvasLayer

signal discussionFinished

var multiDialogList=[]
var currentDiscussionPage=0
var currentDiscussionLine=0

var disableDisplayByCharacter=false

var lastNextFrame=-1

func _process(delta):
	# uniquement quand le dialogue est affiche
	if getWindow().visible and Input.is_action_just_pressed("ui_accept"):
		_on_Button_pressed()
	# fleche "suite" qui clignote
	if getWindow().visible:
		getNextButton().modulate.a=1.0 if (Time.get_ticks_msec()/350)%2==0 else 0.25

func addDiscussion(talker_,discussionList_):
	multiDialogList.append({"talker":talker_,"discussionLineList":discussionList_})

func start():
	setTalker(getCurrentDiscussionTalker())
	getDiscussion().text=getCurrentDiscussionLine()
	getWindow().visible=true
	$Timer.start()

func end():
	getWindow().visible=false
	$Timer.stop()

func _ready():
	getWindow().visible=false
	resetCharacterVisible()

#access
func getWindow():
	return $window

func getNextButton():
	return getWindow().get_node("nextButton")

func getDiscussion():
	return getWindow().get_node("discussion")

func getTalker():
	return getWindow().get_node("talkerTab/talker")

func setTalker(talker_):
	getTalker().text=talker_
	getWindow().get_node("talkerTab").visible=talker_!=""
	# l'onglet reprend la taille du nom
	getWindow().get_node("talkerTab").reset_size()
	


func getCurrentDiscussion():
	return multiDialogList[currentDiscussionPage]

func getCurrentDiscussionTalker():
	return multiDialogList[currentDiscussionPage]["talker"]

func getCurrentDiscussionLine():
	return getCurrentDiscussion()["discussionLineList"][currentDiscussionLine]

func shouldContinueNextPage():
	if currentDiscussionPage < multiDialogList.size()-1:
		return true
	else:
		return false

func shouldContinueNextLine():
	if currentDiscussionLine < getCurrentDiscussion()["discussionLineList"].size()-1:
		return true
	return false

func resetCharacterVisible():
	getDiscussion().set_visible_characters(0)


func next():
	# un seul avancement par frame (Entree peut arriver par plusieurs chemins)
	if lastNextFrame==Engine.get_process_frames():
		return
	lastNextFrame=Engine.get_process_frames()
	if !GlobalPlayer.isDialogAnimationEnabled()  or getDiscussion().get_visible_characters() > getDiscussion().get_total_character_count():
		if shouldContinueNextLine():
			currentDiscussionLine+=1
			resetCharacterVisible()
			getDiscussion().text=getCurrentDiscussionLine()
		elif shouldContinueNextPage():
			currentDiscussionPage+=1
			currentDiscussionLine=0
			resetCharacterVisible()
			setTalker(getCurrentDiscussionTalker())
			getDiscussion().text=getCurrentDiscussionLine()
		else:
			currentDiscussionPage=0
			currentDiscussionLine=0
			resetCharacterVisible()
			disableDisplayByCharacter=true
			emit_signal("discussionFinished")

func displayNextCharacter():
	
	if !GlobalPlayer.isDialogAnimationEnabled()  :
		getDiscussion().set_visible_characters(getDiscussion().get_total_character_count())
	else:
		getDiscussion().set_visible_characters(getDiscussion().get_visible_characters()+1)
	
	if(getDiscussion().get_total_character_count() > getDiscussion().get_visible_characters() ):		
		getNextButton().visible=false
	else:
		getNextButton().visible=true

func _on_Timer_timeout():
	displayNextCharacter()

func _on_Button_pressed():
	next()


