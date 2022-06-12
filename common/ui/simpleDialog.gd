extends CanvasLayer

signal discussionFinished

var multiDialogList=[]
var currentDiscussionPage=0
var currentDiscussionLine=0

var disableDisplayByCharacter=false

func addDiscussion(talker_,discussionList_):
	multiDialogList.append({"talker":talker_,"discussionLineList":discussionList_})

func start():
	getTalker().text=getCurrentDiscussionTalker()
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
	return getWindow().get_node("HBoxContainer/nextButton")

func getDiscussion():
	return getWindow().get_node("HBoxContainer/discussion")

func getTalker():
	return getWindow().get_node("HBoxContainer/talker")
	


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
	if disableDisplayByCharacter or getDiscussion().get_visible_characters() > getDiscussion().get_total_character_count():
		if shouldContinueNextLine():
			currentDiscussionLine+=1
			resetCharacterVisible()
			getDiscussion().text=getCurrentDiscussionLine()
		elif shouldContinueNextPage():
			currentDiscussionPage+=1
			currentDiscussionLine=0
			resetCharacterVisible()
			getTalker().text=getCurrentDiscussionTalker()
			getDiscussion().text=getCurrentDiscussionLine()
		else:
			currentDiscussionPage=0
			currentDiscussionLine=0
			resetCharacterVisible()
			disableDisplayByCharacter=true
			emit_signal("discussionFinished")

func displayNextCharacter():
	
	if disableDisplayByCharacter :
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


