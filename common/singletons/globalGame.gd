extends Node

var _filename=null
var _sceneToLoad=null

const FR='FR'
const EN='EN'

const TRAD_WORD_VENDEUR='Vendeur'
const TRAD_WORD_HABITANT='Habitant'
const TRAD_WORD_PRESENTATEUR='Presentateur'
const TRAD_WORD_APICULTEUR='Apiculteur'
const TRAD_WORD_ARTISAN='Artisan'
const TRAD_WORD_GORDONMOM='gordon_mom'

const TRAD_TREEVILLAGE_START='tree-village_start'
const TRAD_TREEVILLAGE_PENDING='tree-village_pending'
const TRAD_TREEVILLAGE_END='tree-village_end'

const TRAD_TREEVILLAGE_STARFOUND='tree-village_starfound'

const TRAD_TREEVILLAGE_GEMHOUSE_START='tree-village_gemhouse_start'
const TRAD_TREEVILLAGE_GEMHOUSE_PENDING='tree-village_gemhouse_pending'
const TRAD_TREEVILLAGE_GEMHOUSE_END='tree-village_gemhouse_end'

const TRAD_TREEVILLAGE_SHOP='tree-village_shop'
const TRAD_TREEVILLAGE_GORDONHOME='tree-village_gordonhome'


const TRAD_CRABVILLAGE_SHOP='crabvillage_shop'
const TRAD_CRABVILLAGE='crabvillage'

const TRAD_CRABVILLAGE_GAME1_ALREADYWON='crabvillage_game1'
const TRAD_CRABVILLAGE_GAME1_START='crabvillage_game1_start'
const TRAD_CRABVILLAGE_GAME1_WIN='crabvillage_game1_win'

const TRAD_BEARVILLAGE_BEEPLATFORM='beervillage_beeplatform'
const TRAD_BEARVILLAGE_BEEPLATFORM_START='beervillage_beeplatform_start'
const TRAD_BEARVILLAGE_BEEPLATFORM_WIN='beervillage_beeplatform_win'
const TRAD_BEARVILLAGE_BEVILROOM_START='beervillage_bevilroom_start'
const TRAD_BEARVILLAGE_BEVILROOM_WIN='beervillage_bevilroom_win'


const TRAD_BUTTON_NEWGAME='button_newgame'
const TRAD_BUTTON_LOADGAME='button_loadgame'
const TRAD_BUTTON_CREATE='button_create'

const TRAD_LABEL_NOM='label_nom'
const TRAD_LABEL_PSEUDO='label_pseudo'
const TRAD_LABEL_PARTIES='label_parties'

const TRAD_LABEL_VOTREPSEUDO='label_votrepseudo'
const TRAD_BUTTON_RETOUR='button_retour'
const TRAD_BUTTON_EFFACER='button_effacer'
const TRAD_BUTTON_VALIDER='button_valider'

const TRAD_LABEL_RETOURAUMENU='label_retouraumenu'

const TRAD_UI_PAUSE='ui_pause'
const TRAD_UI_RESUME='ui_resume'
const TRAD_UI_INVENTORY='ui_inventory'
const TRAD_UI_SAVE='ui_save'
const TRAD_UI_SETTINGS='ui_settings'
const TRAD_UI_QUIT='ui_quit'
const TRAD_UI_QUIT_CONFIRM='ui_quit_confirm'
const TRAD_UI_QUIT_WARNING='ui_quit_warning'
const TRAD_UI_YES='ui_yes'
const TRAD_UI_NO='ui_no'
const TRAD_UI_SAVED='ui_saved'
const TRAD_UI_TOUCH='ui_touch'
const TRAD_UI_DIALOG_ANIMATION='ui_dialog_animation'
const TRAD_UI_CLOSE='ui_close'
const TRAD_UI_MENU='ui_menu'
const TRAD_UI_SHOP='ui_shop'
const TRAD_UI_EQUIP='ui_equip'
const TRAD_UI_DISPLAY='ui_display'
const TRAD_UI_USE='ui_use'
const TRAD_UI_BUY='ui_buy'
const TRAD_UI_OWNED='ui_owned'

const TRAD_FIGHT_ATTACK='fight_attack'
const TRAD_FIGHT_POTION='fight_potion'
const TRAD_FIGHT_FLEE='fight_flee'
const TRAD_FIGHT_BACK='fight_back'
const TRAD_FIGHT_PUNCH='fight_punch'
const TRAD_FIGHT_SPIDER='fight_spider'
const TRAD_FIGHT_APPEAR='fight_appear'
const TRAD_FIGHT_CHOOSE='fight_choose'
const TRAD_FIGHT_PLAYER_ATTACK='fight_player_attack'
const TRAD_FIGHT_CRITICAL='fight_critical'
const TRAD_FIGHT_ENEMY_ATTACK='fight_enemy_attack'
const TRAD_FIGHT_ENEMY_MISS='fight_enemy_miss'
const TRAD_FIGHT_MISS='fight_miss'
const TRAD_FIGHT_POTION_USED='fight_potion_used'
const TRAD_FIGHT_FLEE_OK='fight_flee_ok'
const TRAD_FIGHT_FLEE_FAIL='fight_flee_fail'
const TRAD_FIGHT_VICTORY='fight_victory'
const TRAD_FIGHT_DEFEAT='fight_defeat'



var lang=FR

var traductionsList={

	TRAD_BUTTON_NEWGAME:{
		FR:'Nouvelle partie',
		EN:'New Game'
	},
	TRAD_BUTTON_LOADGAME:{
		FR:'Charger une partie',
		EN:'Load previous Game'
	},
	TRAD_BUTTON_CREATE:{
		FR:'Crééer',
		EN:'Create'
	},
	TRAD_LABEL_NOM:{
		FR:'Nom',
		EN:'Name'
	},
	TRAD_LABEL_PSEUDO:{
		FR:'Pseudo',
		EN:'Nickname'
	},
	TRAD_LABEL_PARTIES:{
		FR:'Partie(s)',
		EN:'Game(s)'
	},

	TRAD_LABEL_VOTREPSEUDO:{
		FR:'Votre pseudo',
		EN:'You nickname'
	},

	TRAD_BUTTON_RETOUR:{
		FR:'RETOUR',
		EN:'BACK'
	},
	TRAD_BUTTON_EFFACER:{
		FR:'EFFACER',
		EN:'ERASE'
	},
	TRAD_BUTTON_VALIDER:{
		FR:'VALIDER',
		EN:'SUBMIT'
	},

	TRAD_LABEL_RETOURAUMENU:{
		FR:'RETOUR AU MENU',
		EN:'BACK TO THE MENU'
	},

	TRAD_UI_PAUSE:{FR:'Pause',EN:'Pause'},
	TRAD_UI_RESUME:{FR:'Reprendre',EN:'Resume'},
	TRAD_UI_INVENTORY:{FR:'Inventaire',EN:'Inventory'},
	TRAD_UI_SAVE:{FR:'Sauvegarder',EN:'Save'},
	TRAD_UI_SETTINGS:{FR:'Paramètres',EN:'Settings'},
	TRAD_UI_QUIT:{FR:'Quitter',EN:'Quit'},
	TRAD_UI_QUIT_CONFIRM:{FR:'Quitter la partie ?',EN:'Quit the game?'},
	TRAD_UI_QUIT_WARNING:{FR:'Pensez à sauvegarder !',EN:'Remember to save!'},
	TRAD_UI_YES:{FR:'Oui',EN:'Yes'},
	TRAD_UI_NO:{FR:'Non',EN:'No'},
	TRAD_UI_SAVED:{FR:'Partie sauvegardée',EN:'Game saved'},
	TRAD_UI_TOUCH:{FR:'Commandes tactiles',EN:'Touch controls'},
	TRAD_UI_DIALOG_ANIMATION:{FR:'Texte animé',EN:'Animated text'},
	TRAD_UI_CLOSE:{FR:'Fermer',EN:'Close'},
	TRAD_UI_MENU:{FR:'Menu',EN:'Menu'},
	TRAD_UI_SHOP:{FR:'Boutique',EN:'Shop'},
	TRAD_UI_EQUIP:{FR:'Equiper',EN:'Equip'},
	TRAD_UI_DISPLAY:{FR:'Afficher',EN:'Show'},
	TRAD_UI_USE:{FR:'Utiliser',EN:'Use'},
	TRAD_UI_BUY:{FR:'Acheter',EN:'Buy'},
	TRAD_UI_OWNED:{FR:'Déjà possédé',EN:'Owned'},

	TRAD_FIGHT_ATTACK:{FR:'Attaquer',EN:'Attack'},
	TRAD_FIGHT_POTION:{FR:'Potion x%d',EN:'Potion x%d'},
	TRAD_FIGHT_FLEE:{FR:'Fuir',EN:'Flee'},
	TRAD_FIGHT_BACK:{FR:'Retour',EN:'Back'},
	TRAD_FIGHT_PUNCH:{FR:'Coup de poing',EN:'Punch'},
	TRAD_FIGHT_SPIDER:{FR:'Araignée',EN:'Spider'},
	TRAD_FIGHT_APPEAR:{FR:'Une araignée surgit !',EN:'A spider appears!'},
	TRAD_FIGHT_CHOOSE:{FR:'Que fait %s ?',EN:'What will %s do?'},
	TRAD_FIGHT_PLAYER_ATTACK:{FR:'%s : %s !',EN:'%s uses %s!'},
	TRAD_FIGHT_CRITICAL:{FR:'Coup critique !',EN:'Critical hit!'},
	TRAD_FIGHT_ENEMY_ATTACK:{FR:"L'araignée attaque !",EN:'The spider attacks!'},
	TRAD_FIGHT_ENEMY_MISS:{FR:"L'araignée rate son coup !",EN:'The spider misses!'},
	TRAD_FIGHT_MISS:{FR:'Raté',EN:'Miss'},
	TRAD_FIGHT_POTION_USED:{FR:'%s boit une potion.',EN:'%s drinks a potion.'},
	TRAD_FIGHT_FLEE_OK:{FR:'Vous prenez la fuite !',EN:'You got away!'},
	TRAD_FIGHT_FLEE_FAIL:{FR:'Impossible de fuir !',EN:"Can't escape!"},
	TRAD_FIGHT_VICTORY:{FR:'Victoire ! +%d XP  +%d gemmes',EN:'Victory! +%d XP  +%d gems'},
	TRAD_FIGHT_DEFEAT:{FR:'%s est épuisé et recule...',EN:'%s is exhausted and retreats...'},


	TRAD_WORD_PRESENTATEUR:{
		FR:"Présentateur",
		EN:"Presenter"
	},
	TRAD_WORD_APICULTEUR:{
		FR:"Apiculteur",
		EN:"Beekeeper"
	},
	TRAD_WORD_VENDEUR:{
		FR:"Vendeur",
		EN:"Seller"
	},
	TRAD_WORD_GORDONMOM:{
		FR:"Maman de Godron",
		EN:"Gordon's Mom"
	},
	
	TRAD_WORD_ARTISAN:{
		FR:"Artisan",
		EN:"Craftsman"
	},
	
	TRAD_WORD_HABITANT:{
		FR: "Habitant",
		EN: "Citizen"
	},

	#tree village
	TRAD_TREEVILLAGE_END:{
		FR:[
			["Bonjour Gordon !","Tu peux m'aider à réparer le puits ?"],
			[
				"Oui je pense, j'ai",
				"- vos clous;",
				"- le miel pour sceller les pierres;",
				"- et un nouveau seau. :)"
			],
			["Félicitations Gordon !","Je vais pouvoir réparer."],

		],
		EN:[
			["Hi Gordon !","Can you help me to repair the well ?"],
			[
				"Yes i think, i have",
				"- your nails;",
				"- honey to stick stones;",
				"- and a new bucket. :)"
			],
			["Congratulations Gordon !","I can repair now."],

		],
	},
	TRAD_TREEVILLAGE_PENDING:{
		FR:[
			["Bonjour Gordon !","Tu peux m'aider à réparer le puits ?"],
			[
				"Bonjour,",
				"Oui je pense, mais il me manque encore des objets...",
				"Il me manque"
				
			],
			"- les clous",
			"- le miel pour sceller les pierres",
			"- le nouveau seau"
		],
		EN:[
			["Hi Gordon !","Can you help me to repair the well ?"],
			[
				"Hi,",
				"Yes i think, but i miss some objects...",
				"i miss"
				
			],
			"- nails",
			"- honey, to stick stones",
			"- and a new bucket"
		]
	},
	TRAD_TREEVILLAGE_START:{
		FR:[
			["Bonjour Gordon !","Tu peux m'aider à réparer le puits ?"],
			["Bonjour monsieur.","Oui bien sûr, comment ?"],
			[
				"Il me faudrait de quoi sceller les pierres,",
				" des clous pour refixer l'armature en bois",
				" et un nouveau seau."
			],
			["Où puis-je trouver ça ?"],
			[
				"Tu devras parcourir les différents villages autour de nous,",
				" mais fais attention...",
				" des dangers guêtent dans nos forêts..."
			]
		],
		EN:[
			["Hi Gordon !","Can you help me to repair the well ?"],
			["Hi","Yes of course, how ?"],
			[
				"I need something to stick stones,",
				" some nails to repair wood structure",
				" and a new bucket."
			],
			["Where can i find it ?"],
			[
				"You should explore some villages around us,",
				" but you should be careful...",
				" there are dangers in woods ..."
			]
		],
	},

	TRAD_TREEVILLAGE_GEMHOUSE_START:{
		FR:[
			["Bonjour Gordon","Que puis-je pour toi ?"],
			["Bonjour Monsieur","Je souhaiterais gagner des Gems pour acheter une épée."],
			["Il y a des étoiles de Gormon enterrées dans notre village.","Si tu m'en rapportes, je te les echangerais contre une Gem chacunes","Ça t'intéresse ?"],
			["Oui, ça m'interesse mais comment les trouver ?"],
			["Je vais te donner une carte et une pelle."],
			["Merci pour la pelle et la carte."]
		],
		EN:[
			["Hi Gordon","What do you want ?"],
			["Hi","I want earn Gems to buy a sword."],
			["There are some Gormon star buried in our village.","I you give to me, i will give you one Gem per star","You want it ?"],
			["Yes, but how to find them ?"],
			["I will give to you a map and spade."],
			["Thanks, i got it, bye."]
		]
	},

	TRAD_TREEVILLAGE_GEMHOUSE_PENDING:{
		FR:[
			["Bonjour Gordon","Tu as trouvé toutes les étoiles ?"],
			[
				"Bonjour Monsieur.",
				"Non pas encore, il m'en reste encore des étoiles à trouver"
			],
			[
				"Bonjour Monsieur.",
				"Oui, je les ai toutes trouver",
				"Les voilà !"
			],
			["Merci pour les étoiles de Gormon.","Voilà tes 10 Gems."]
		],
		EN:[
			["Hi Gordon","Do you find all stars ?"],
			[
				"Hi.",
				"No for the moment, i have no find all yet"
			],
			[
				"Hi.",
				"Yes i found all",
				"There it is!"
			],
			["Thanks for Gormon stars.","I give to you 10 Gems."]
		]
	},

	TRAD_TREEVILLAGE_GEMHOUSE_END:{
		FR:[
			["Bonjour Gordon.","Désolé, je n'ai plus de mission pour toi ;)"]
		],
		EN:[
			["Hi Gordon.","Sorry, i have no mission to you ;)"]
		]
	},

	TRAD_TREEVILLAGE_SHOP:{
		FR:[
			["Bonjour Gordon","Que souhaites-tu ?"],
			["Bonjour monsieur","Je souhaiterais acheter un objet"],
			["Je vais t’afficher les produits en vente","Tu n’auras qu’a choisir"]
		],
		EN:[
			["Hi Gordon","What do you want ?"],
			["Hi","I want to buy an item"],
			["I will diplay to you some products i sell","You should choose one"]
		]
	},

	TRAD_TREEVILLAGE_GORDONHOME:{
		FR:[
			["Bonjour Gordon."],
			["Bonjour Maman, comment va Papa ?"],
			["Il est encore mal en point...",
			"depuis la tempête qui a ravagé le puits..",
			"Le problème c'est qu'en son absence,",
			"personne ne peut aider notre artisan",
			"a réparer notre unique puits...",
			]
		],
		EN:[
			["Hi Gordon."],
			["Hi Mom, how do Dad ?"],
			["He is not feeling well...",
			"since the storm which broke the well..",
			"The problem is with his absence,",
			"nobody can help crafsman ",
			"to repair the well...",
			]
		]
	},

	#crab village

	TRAD_CRABVILLAGE:{
		FR:[
			[
				"Bonjour jeune inconnu."
			],
			[
				"Bonjour,",
				"Il me faudrait des clous",
				"Pour réparer notre puits."
			],
			[
				"Tu es au bon endroit,",
				"Remporte les 2 épreuves.",
				"Ils te donneront un jeton",
				"Que tu pourras échanger",
				"Dans la boutique."
			]
		],
		EN:[
			[
				"Hi."
			],
			[
				"Hi,",
				"I want to buy some nails",
				"To repair our well."
			],
			[
				"You have found the right place,",
				"Win this two challenges.",
				"They will give to you  a token",
				"You will exchange it",
				"In the shop."
			]
		]

	},

	TRAD_CRABVILLAGE_GAME1_ALREADYWON:{
		FR:[
			"Re-bonjour,",
			"Désolé, mais vous avez déjà gagné...",
			],
		EN:[
			"Hi,",
			"Sorry but you have already won...",
			]	
	},
	TRAD_CRABVILLAGE_GAME1_START:{
		FR:[
			"Bonjour, pour remporter ce jeu",
			"Vous devez faire traverser",
			"Le crabe, l'algue et la méduse.",
			"Vous pouvez en tranporter un seul à la fois",
			"Attention si vous laissez seuls certains :",
			"Le crabe mange la méduse,",
			"La méduse mange l'algue."
			],
		EN:[
			"Hi, to win this game",
			"You will crosses",
			"The crab, the seaweed and the medusa.",
			"You can carry only one on the wooden raft",
			"Take care, if you let alone :",
			"The crab eat the medusa,",
			"The medusa eat the seaweed."
			],

	},
	TRAD_CRABVILLAGE_GAME1_WIN:{
		FR:[
			"Félicitations, tu remportes ce jeu !",
			"Voici 2 Gems en récompense."
			],
		EN:[
			"Congratulations, you win !",
			"Take 2 Gems."
			],

	},

	
	TRAD_CRABVILLAGE_SHOP:{
		FR:[
		"Bonjour,",
		"Choisis parmi nos produits",
		"Celui de ton choix."
		],
		EN:[
		"Hi,",
		"Choose in list",
		"Product you want."
		]	
	},

	#bear village
	
	TRAD_BEARVILLAGE_BEEPLATFORM:{
		FR:[
			
		],
		EN:[
			
		]
		
	},

	TRAD_BEARVILLAGE_BEEPLATFORM_START:{
		FR:[
			"Bonjour,",
			"Peux-tu m'aider à récuperer mon miel  ?",
			"Il te faudra aller à la ruche et me ramener mes 3 sceaux"
		],
		EN:[
			"Hi,",
			"Can you help me to get the honey  ?",
			"You should go to the honey house and get 3 bucket"
		],
	},

	TRAD_BEARVILLAGE_BEEPLATFORM_WIN:{
		FR:[
			"Bravo,",
			"Merci beaucoup",
			"Voila 4 Gems pour te remercier"
		],
		EN:[
			"Congratulations,",
			"Thanks a lot",
			"I give to you 4 Gems"
		],

	},

	TRAD_BEARVILLAGE_BEVILROOM_START:{
		FR:[
			"Bonjour,",
			"Peux tu m'aider ?",
			"Nous avons depuis quelques jours de méchantes BeVil",
			"Qui nous empêchent d'accéder à la ruche."
		],
		EN:[
			"Hi,",
			"Can you help me ?",
			"There are since few days bad BeVil",
			"They deny us to go to the hive."
		],

	},

	TRAD_BEARVILLAGE_BEVILROOM_WIN:{
		FR:[
			"Bravo,",
			"Un grand merci pour ton aide !",
			"Pour te remercier, voici 4 Gems"
		],
		EN:[
			"Congratulations,",
			"Thanks a lot !",
			"I give to you 4 Gems"
		],

	},

	TRAD_TREEVILLAGE_STARFOUND:{
		FR:"Une étoile de Gormon trouvée !!",
		EN:"One Gormon Star found !!",
		
	}


}

func setLang(lang_):
	lang=lang_

func getLang():
	return lang
	
func getTraductionById(id_):
	return traductionsList[id_][lang]

func getSceneToLoad():
	return _sceneToLoad

func create(nickname_):
	var scene='screens/tree-village/gordon-home.tscn'
	_filename=getNewFilename(nickname_)
	GlobalPlayer.setNickname(nickname_)
	GlobalPlayer.savePosition(Vector2(48,75))
	save(scene)
	loadFile(_filename)

func saveWithPosition(scene_,position_):
	GlobalPlayer.savePosition(position_)
	save(scene_)

func save(scene_):
	print("save :"+_filename)
	var gameData=getDataToSave(scene_)
	var saveFile = FileAccess.open("user://"+_filename, FileAccess.WRITE)
	if saveFile == null:
		push_error("Erreur lors de l'ecriture de la sauvegarde user://"+_filename)
		return
	saveFile.store_line(JSON.stringify(gameData))
	saveFile.close()

func getNewFilename(nickname_):
	var filePattern=nickname_+"_"
	var newId=1
	var saveList=getList()
	for saveFile in saveList:
		if(saveFile.substr(0,nickname_.length())==nickname_):
			newId+=1
	return filePattern+str(newId)+".save"

func getFilteredSaveList(fileList_):
	var filterSaveList=[]
	for file in fileList_:
		if file.ends_with('.save'):
			filterSaveList.append(file)
	return filterSaveList	
	

func getList():
	var path="user://"
	var fileList=[]
	var dir = DirAccess.open(path)
	if dir != null:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if(file_name.substr(0,1)!="."):
				fileList.append(file_name)
			file_name = dir.get_next()
		
		dir.list_dir_end()
	else:
		push_error("Erreur lors de l'access au repertoire user://")
	
	return getFilteredSaveList(fileList)

func convertObjectToSave(object_,fieldList_):
	var saveData={}
	for field in fieldList_:
		saveData[field]=object_.get(field)
	return saveData


func gotoMenu():
	SceneTransition.change_scene("res://screens/game/menu.tscn")


func getDataToSave(scene_):
	var gameData= {
		"scene" : scene_,
		"player":GlobalPlayer.convertToSave(),
		"scenes":GlobalScenes.convertToSave(),
	}
	return gameData
	
		
func loadFile(file_):
	_filename=file_
	var saveFilename="user://"+file_
	if not FileAccess.file_exists(saveFilename):
		return # Error! We don't have a save to load.
	
	var saveFile = FileAccess.open(saveFilename, FileAccess.READ)
	while saveFile.get_position() < saveFile.get_length():
		# Get the saved dictionary from the next line in the save file
		var saveData = JSON.parse_string(saveFile.get_line())
		if not saveData is Dictionary:
			continue
		for field in saveData.keys():
			if field=="scene":
				_sceneToLoad=saveData[field]
			elif field=="player":
				GlobalPlayer.loadFromSave(saveData[field])
			elif field=="scenes":
				GlobalScenes.loadFromSave(saveData[field])
		
	saveFile.close()


	
