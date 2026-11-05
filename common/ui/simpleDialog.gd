extends CanvasLayer

signal discussionFinished

var multiDialogList=[]
var currentDiscussionPage=0
var currentDiscussionLine=0

var disableDisplayByCharacter=false

var lastNextFrame=-1

const PORTRAIT_DIR="res://common/ui/portraits/"
# position du nom et du texte, sans et avec portrait
const TALKER_X=6.0
const DISCUSSION_X=7.0
const TALKER_X_PORTRAIT=50.0
const DISCUSSION_X_PORTRAIT=52.0

func _process(delta):
	# uniquement quand le dialogue est affiche
	if getWindow().visible and Input.is_action_just_pressed("ui_accept"):
		_on_Button_pressed()
	# fleche "suite" qui clignote
	if getWindow().visible:
		getNextButton().modulate.a=1.0 if (Time.get_ticks_msec()/350)%2==0 else 0.25

func addDiscussion(talker_,discussionList_):
	multiDialogList.append({"talker":talker_,"discussionLineList":discussionList_})

func clearDiscussion():
	multiDialogList=[]
	currentDiscussionPage=0
	currentDiscussionLine=0

func start():
	setTalker(getCurrentDiscussionTalker())
	getDiscussion().text=getCurrentDiscussionLine()
	refreshPortrait()
	var wasVisible=getWindow().visible
	# l'appui qui ouvre le dialogue ne doit pas aussi afficher tout le texte
	lastNextFrame=Engine.get_process_frames()
	getWindow().visible=true
	add_to_group(GlobalGame.DIALOG_GROUP)
	$Timer.start()
	if !wasVisible:
		_openAnimation()

# la fenetre se deplie verticalement (ouverture facon 16 bits)
func _openAnimation():
	var window=getWindow()
	window.pivot_offset=window.size/2
	window.scale=Vector2(1, 0.1)
	var tween=window.create_tween()
	tween.tween_property(window, "scale:y", 1.0, 0.12).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func end():
	getWindow().visible=false
	remove_from_group(GlobalGame.DIALOG_GROUP)
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
	


# portraits
# les noms affiches sont deja traduits : on retrouve la cle en comparant
# avec la traduction de chaque nom connu. "Vendeur" depend de la boutique.
func getPortraitByTalker():
	return {
		GlobalGame.TRAD_WORD_GORDON:"gordon",
		GlobalGame.TRAD_WORD_GORDONMOM:"mom",
		GlobalGame.TRAD_WORD_ARTISAN:"craftsman",
		GlobalGame.TRAD_WORD_APICULTEUR:"bear",
		GlobalGame.TRAD_WORD_HABITANT:"crab",
		GlobalGame.TRAD_WORD_PRESENTATEUR:"crabPresenter",
	}

func getPortraitByScene():
	return {
		"res://screens/tree-village/shop.tscn":{GlobalGame.TRAD_WORD_VENDEUR:"seller"},
		"res://screens/tree-village/gem-house.tscn":{GlobalGame.TRAD_WORD_VENDEUR:"gemSeller"},
		"res://screens/bear-village/shop.tscn":{GlobalGame.TRAD_WORD_VENDEUR:"bearSeller"},
		"res://screens/crabs-village/shop.tscn":{GlobalGame.TRAD_WORD_VENDEUR:"crab"},
	}

func getPortraitName(talker_, scenePath_):
	var candidates=getPortraitByTalker()
	if getPortraitByScene().has(scenePath_):
		candidates.merge(getPortraitByScene()[scenePath_], true)
	for key in candidates:
		if GlobalGame.getTraductionById(key)==talker_:
			return candidates[key]
	return ""

# expression contente quand la replique s'exclame
func isHappyLine(line_):
	return line_.strip_edges().ends_with("!")

func getPortraitPath(talker_, line_, scenePath_):
	var portraitName=getPortraitName(talker_, scenePath_)
	if portraitName=="":
		return ""
	if isHappyLine(line_):
		portraitName+="-happy"
	return PORTRAIT_DIR+portraitName+".png"

func getPortrait():
	return getWindow().get_node("portrait")

func refreshPortrait():
	var scenePath=""
	if get_tree().current_scene:
		scenePath=get_tree().current_scene.scene_file_path
	var path=getPortraitPath(getCurrentDiscussionTalker(), getCurrentDiscussionLine(), scenePath)
	var hasPortrait=path!=""
	getPortrait().visible=hasPortrait
	if hasPortrait:
		getPortrait().get_node("face").texture=load(path)
	getWindow().get_node("talkerTab").position.x=TALKER_X_PORTRAIT if hasPortrait else TALKER_X
	var discussion=getDiscussion()
	var right=discussion.offset_right
	discussion.offset_left=DISCUSSION_X_PORTRAIT if hasPortrait else DISCUSSION_X
	discussion.offset_right=right

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
	# texte encore en cours d'ecriture : un appui l'affiche en entier
	if GlobalPlayer.isDialogAnimationEnabled() and getDiscussion().get_visible_characters() <= getDiscussion().get_total_character_count():
		getDiscussion().set_visible_characters(getDiscussion().get_total_character_count()+1)
		getNextButton().visible=true
		return
	if !GlobalPlayer.isDialogAnimationEnabled()  or getDiscussion().get_visible_characters() > getDiscussion().get_total_character_count():
		if shouldContinueNextLine():
			currentDiscussionLine+=1
			resetCharacterVisible()
			getDiscussion().text=getCurrentDiscussionLine()
			refreshPortrait()
		elif shouldContinueNextPage():
			currentDiscussionPage+=1
			currentDiscussionLine=0
			resetCharacterVisible()
			setTalker(getCurrentDiscussionTalker())
			getDiscussion().text=getCurrentDiscussionLine()
			refreshPortrait()
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
		# "bip" de frappe une lettre sur trois
		var shown=getDiscussion().get_visible_characters()
		if shown <= getDiscussion().get_total_character_count() and shown%3==0:
			Sfx.play(Sfx.TEXT)
	
	if(getDiscussion().get_total_character_count() > getDiscussion().get_visible_characters() ):		
		getNextButton().visible=false
	else:
		getNextButton().visible=true

func _on_Timer_timeout():
	displayNextCharacter()

func _on_Button_pressed():
	next()


