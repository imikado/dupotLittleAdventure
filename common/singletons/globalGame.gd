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
const TRAD_WORD_GORDON='gordon'

const TRAD_TREEVILLAGE_START='tree-village_start'
const TRAD_TREEVILLAGE_PENDING='tree-village_pending'
const TRAD_TREEVILLAGE_END='tree-village_end'

const TRAD_TREEVILLAGE_STARFOUND='tree-village_starfound'

const TRAD_TREEVILLAGE_GEMHOUSE_START='tree-village_gemhouse_start'
const TRAD_TREEVILLAGE_GEMHOUSE_PENDING='tree-village_gemhouse_pending'
const TRAD_TREEVILLAGE_GEMHOUSE_END='tree-village_gemhouse_end'

const TRAD_TREEVILLAGE_SHOP='tree-village_shop'
const TRAD_TREEVILLAGE_GORDONHOME='tree-village_gordonhome'
const TRAD_TREEVILLAGE_GORDONHOME_HEAL='tree-village_gordonhome_heal'


const TRAD_CRABVILLAGE_SHOP='crabvillage_shop'
const TRAD_CRABVILLAGE='crabvillage'

const TRAD_CRABVILLAGE_GAME1_ALREADYWON='crabvillage_game1'
const TRAD_CRABVILLAGE_GAME1_START='crabvillage_game1_start'
const TRAD_CRABVILLAGE_GAME1_WIN='crabvillage_game1_win'
# les jeux 2 et 3 reprennent les textes "deja gagne" et "victoire" du jeu 1
const TRAD_CRABVILLAGE_GAME2_START='crabvillage_game2_start'
const TRAD_CRABVILLAGE_GAME3_START='crabvillage_game3_start'
const TRAD_BEARVILLAGE_SHOP='beervillage_shop'

const TRAD_BEARVILLAGE_BEEPLATFORM='beervillage_beeplatform'
const TRAD_BEARVILLAGE_BEEPLATFORM_START='beervillage_beeplatform_start'
const TRAD_BEARVILLAGE_BEEPLATFORM_WIN='beervillage_beeplatform_win'
const TRAD_BEARVILLAGE_BEEPLATFORM_REPLAY='beervillage_beeplatform_replay'
const TRAD_BEARVILLAGE_BEVILROOM_START='beervillage_bevilroom_start'
const TRAD_BEARVILLAGE_BEVILROOM_WIN='beervillage_bevilroom_win'
const TRAD_BEARVILLAGE_BEVILROOM_REPLAY='beervillage_bevilroom_replay'


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
const TRAD_END_TITLE='end_title'
const TRAD_END_MESSAGE='end_message'
const TRAD_END_PARTY='end_party'
const TRAD_TITLE_PRESS_KEY='title_press_key'
const TRAD_TITLE_TOUCH='title_touch'
const TRAD_CREDITS_GAME='credits_game'
const TRAD_CREDITS_CAST='credits_cast'
const TRAD_CREDITS_BEARS='credits_bears'
const TRAD_CREDITS_BEVIL='credits_bevil'
const TRAD_CREDITS_CRABS='credits_crabs'
const TRAD_CREDITS_SPIDER='credits_spider'
const TRAD_CREDITS_FONT_TITLE='credits_font_title'
const TRAD_CREDITS_FONT='credits_font'
const TRAD_CREDITS_ENGINE_TITLE='credits_engine_title'
const TRAD_CREDITS_ENGINE='credits_engine'
const TRAD_CREDITS_LICENSE_TITLE='credits_license_title'
const TRAD_CREDITS_LICENSE='credits_license'
const TRAD_CREDITS_MORE='credits_more'

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
const TRAD_UI_SOUND='ui_sound'
const TRAD_UI_CLOSE='ui_close'
const TRAD_UI_MENU='ui_menu'
const TRAD_MAP_TREEVILLAGE='map_tree-village'
const TRAD_MAP_CRABVILLAGE='map_crab-village'
const TRAD_MAP_BEARVILLAGE='map_bear-village'
const TRAD_MAP_SPIDERWEB='map_spider-web'
const TRAD_MAP_ENTER='map_enter'
const TRAD_UI_SHOP='ui_shop'
const TRAD_UI_EQUIP='ui_equip'
const TRAD_UI_EQUIPPED='ui_equipped'
const TRAD_UI_RESET='ui_reset'
const TRAD_UI_GOALS='ui_goals'
const TRAD_GOALS_WELL='goals_well'
const TRAD_GOALS_SWORD='goals_sword'
const TRAD_GOALS_NAILS='goals_nails'
const TRAD_GOALS_BEARS='goals_bears'
const TRAD_GOALS_STARS='goals_stars'
const TRAD_UI_REPLAY='ui_replay'
const TRAD_UI_RESTART='ui_restart'
const TRAD_UI_DISPLAY='ui_display'
const TRAD_UI_USE='ui_use'
const TRAD_UI_BUY='ui_buy'
const TRAD_UI_OWNED='ui_owned'
const TRAD_UI_NOT_ENOUGH_GEMS='ui_not_enough_gems'
const TRAD_UI_YOUR_GEMS='ui_your_gems'
const TRAD_UI_LANGUAGE='ui_language'

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
const TRAD_FIGHT_TIP='fight_tip'
const TRAD_FIGHT_PERFECT='fight_perfect'
const TRAD_FIGHT_PARRY='fight_parry'



# langue choisie par le joueur, retenue d'un lancement à l'autre
const SETTINGS_FILE="user://settings.cfg"

var lang=FR

var traductionsList={

	TRAD_BUTTON_NEWGAME:{
		FR:'Nouvelle partie',
		EN:'New Game'
	},
	TRAD_BUTTON_LOADGAME:{
		FR:'Charger une partie',
		EN:'Load a game'
	},
	TRAD_BUTTON_CREATE:{
		FR:'Créer',
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
		EN:'Your nickname'
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
	TRAD_UI_SOUND:{FR:'Bruitages',EN:'Sound effects'},
	TRAD_UI_CLOSE:{FR:'Fermer',EN:'Close'},
	TRAD_UI_MENU:{FR:'Menu',EN:'Menu'},
	TRAD_MAP_TREEVILLAGE:{FR:'Village des arbres',EN:'Tree village'},
	TRAD_MAP_CRABVILLAGE:{FR:'Village des crabes',EN:'Crab village'},
	TRAD_MAP_BEARVILLAGE:{FR:'Village des ours',EN:'Bear village'},
	TRAD_MAP_SPIDERWEB:{FR:'Toile des araignées',EN:'Spider web'},
	TRAD_MAP_ENTER:{FR:'Entrer',EN:'Enter'},
	TRAD_UI_SHOP:{FR:'Boutique',EN:'Shop'},
	TRAD_UI_EQUIP:{FR:'Équiper',EN:'Equip'},
	TRAD_UI_EQUIPPED:{FR:'Équipé',EN:'Equipped'},
	TRAD_UI_RESET:{FR:'Recommencer',EN:'Restart'},
	TRAD_UI_GOALS:{FR:'Objectifs',EN:'Goals'},
	TRAD_GOALS_WELL:{FR:'Pour réparer le puits :',EN:'To repair the well:'},
	TRAD_GOALS_SWORD:{FR:'boutique',EN:'shop'},
	TRAD_GOALS_NAILS:{FR:'crabes',EN:'crabs'},
	TRAD_GOALS_BEARS:{FR:'ours',EN:'bears'},
	TRAD_GOALS_STARS:{FR:'Étoiles de Gormon %d/%d',EN:'Gormon stars %d/%d'},
	TRAD_UI_REPLAY:{FR:'Rejouer',EN:'Play again'},
	TRAD_UI_RESTART:{FR:'Recommencer ?',EN:'Try again?'},
	TRAD_UI_DISPLAY:{FR:'Afficher',EN:'Show'},
	TRAD_UI_USE:{FR:'Utiliser',EN:'Use'},
	TRAD_UI_BUY:{FR:'Acheter',EN:'Buy'},
	TRAD_UI_OWNED:{FR:'Déjà possédé',EN:'Owned'},
	TRAD_UI_NOT_ENOUGH_GEMS:{FR:'Pas assez de gemmes',EN:'Not enough gems'},
	TRAD_UI_YOUR_GEMS:{FR:'Tes gemmes :',EN:'Your gems:'},
	TRAD_UI_LANGUAGE:{FR:'Langue : Français',EN:'Language: English'},

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
	TRAD_END_TITLE:{FR:'Fin',EN:'The End'},
	TRAD_END_MESSAGE:{FR:"Le puits est réparé !\nMerci d'avoir joué.",EN:'The well is fixed!\nThanks for playing.'},
	TRAD_END_PARTY:{FR:'Le puits coule à nouveau !',EN:'The well flows again!'},
	TRAD_TITLE_PRESS_KEY:{FR:'Appuyez sur une touche',EN:'Press any key'},
	TRAD_TITLE_TOUCH:{FR:"Touchez l'écran",EN:'Tap the screen'},
	TRAD_CREDITS_GAME:{FR:'Un jeu de Dupot',EN:'A game by Dupot'},
	TRAD_CREDITS_CAST:{FR:'Avec',EN:'Starring'},
	TRAD_CREDITS_BEARS:{FR:'Les ours',EN:'The bears'},
	TRAD_CREDITS_BEVIL:{FR:'Les BeVil',EN:'The BeVils'},
	TRAD_CREDITS_CRABS:{FR:'Les crabes',EN:'The crabs'},
	TRAD_CREDITS_SPIDER:{FR:"L'araignée",EN:'The spider'},
	TRAD_CREDITS_FONT_TITLE:{FR:'Police',EN:'Font'},
	TRAD_CREDITS_FONT:{FR:'Pixel Operator\npar Jayvee Enaguas (CC0)',EN:'Pixel Operator\nby Jayvee Enaguas (CC0)'},
	TRAD_CREDITS_ENGINE_TITLE:{FR:'Moteur',EN:'Engine'},
	TRAD_CREDITS_ENGINE:{FR:'Godot Engine',EN:'Godot Engine'},
	TRAD_CREDITS_LICENSE_TITLE:{FR:'Licence',EN:'License'},
	TRAD_CREDITS_LICENSE:{FR:'GNU LGPL 2.1',EN:'GNU LGPL 2.1'},
	TRAD_CREDITS_MORE:{FR:"D'autres jeux sur\ndupot.org",EN:'More games at\ndupot.org'},
	TRAD_FIGHT_TIP:{FR:'Appuie au « ! » pour un bonus !',EN:'Press at "!" for a bonus!'},
	TRAD_FIGHT_PERFECT:{FR:'Parfait !',EN:'Perfect!'},
	TRAD_FIGHT_PARRY:{FR:'Paré !',EN:'Blocked!'},


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
	TRAD_WORD_GORDON:{
		FR:"Gordon",
		EN:"Gordon"
	},
	TRAD_WORD_GORDONMOM:{
		FR:"Maman de Gordon",
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
				"Oui, je pense. J'ai :",
				"- vos clous ;",
				"- le miel pour sceller les pierres ;",
				"- et un nouveau seau. :)"
			],
			["Félicitations Gordon !","Je vais pouvoir réparer."],

		],
		EN:[
			["Hi Gordon!","Can you help me repair the well?"],
			[
				"Yes, I think so. I have:",
				"- your nails;",
				"- honey to seal the stones;",
				"- and a new bucket. :)"
			],
			["Congratulations Gordon!","Now I can repair it."],

		],
	},
	TRAD_TREEVILLAGE_PENDING:{
		FR:[
			["Bonjour Gordon !","Tu peux m'aider à réparer le puits ?"],
			[
				"Bonjour,",
				"Oui, je pense, mais il me manque encore des objets...",
				"Il me manque :"
				
			],
			"- les clous",
			"- le miel pour sceller les pierres",
			"- le nouveau seau"
		],
		EN:[
			["Hi Gordon!","Can you help me repair the well?"],
			[
				"Hi,",
				"Yes, I think so, but some things are still missing...",
				"I still need:"
				
			],
			"- nails",
			"- honey to seal the stones",
			"- a new bucket"
		]
	},
	TRAD_TREEVILLAGE_START:{
		FR:[
			["Bonjour Gordon !","Tu peux m'aider à réparer le puits ?"],
			["Bonjour monsieur.","Oui bien sûr, comment ?"],
			[
				"Il me faudrait de quoi sceller les pierres,",
				"des clous pour refixer l'armature en bois",
				"et un nouveau seau."
			],
			["Où puis-je trouver tout ça ?"],
			[
				"Tu devras parcourir les villages autour de nous,",
				"mais fais attention...",
				"des dangers guettent dans nos forêts..."
			]
		],
		EN:[
			["Hi Gordon!","Can you help me repair the well?"],
			["Hello sir.","Yes of course, how?"],
			[
				"I need something to seal the stones,",
				"some nails to fix the wooden frame",
				"and a new bucket."
			],
			["Where can I find all that?"],
			[
				"You will have to explore the villages around us,",
				"but be careful...",
				"dangers lurk in our woods..."
			]
		],
	},

	TRAD_TREEVILLAGE_GEMHOUSE_START:{
		FR:[
			["Bonjour Gordon","Que puis-je pour toi ?"],
			["Bonjour monsieur","Je voudrais gagner des gemmes pour acheter une épée."],
			["Il y a des étoiles de Gormon enterrées dans notre village.","Si tu me les rapportes toutes, je te donnerai 2 gemmes par étoile.","Ça t'intéresse ?"],
			["Oui ! Mais comment les trouver ?"],
			["Je vais te donner une carte et une pelle.","Équipe la pelle et creuse là où le sol brille."],
			["Merci pour la pelle et la carte."]
		],
		EN:[
			["Hi Gordon","What can I do for you?"],
			["Hello sir","I'd like to earn gems to buy a sword."],
			["Some Gormon stars are buried in our village.","If you bring me all of them, I'll give you 2 gems per star.","Interested?"],
			["Yes! But how can I find them?"],
			["I'll give you a map and a spade.","Equip the spade and dig where the ground sparkles."],
			["Thanks for the spade and the map."]
		]
	},

	TRAD_TREEVILLAGE_GEMHOUSE_PENDING:{
		FR:[
			["Bonjour Gordon","Tu as trouvé toutes les étoiles ?"],
			[
				"Bonjour monsieur.",
				"Non, pas encore. Il me reste des étoiles à trouver."
			],
			[
				"Bonjour monsieur.",
				"Oui, je les ai toutes trouvées !",
				"Les voilà !"
			],
			["Merci pour les étoiles de Gormon.","Voilà tes 10 gemmes."]
		],
		EN:[
			["Hi Gordon","Did you find all the stars?"],
			[
				"Hello sir.",
				"Not yet, there are still some stars to find."
			],
			[
				"Hello sir.",
				"Yes, I found them all!",
				"Here they are!"
			],
			["Thanks for the Gormon stars.","Here are your 10 gems."]
		]
	},

	TRAD_TREEVILLAGE_GEMHOUSE_END:{
		FR:[
			["Bonjour Gordon.","Désolé, je n'ai plus de mission pour toi ;)"]
		],
		EN:[
			["Hi Gordon.","Sorry, I have no more missions for you ;)"]
		]
	},

	TRAD_TREEVILLAGE_SHOP:{
		FR:[
			["Bonjour Gordon","Que souhaites-tu ?"],
			["Bonjour monsieur","Je voudrais acheter un objet."],
			["Je vais t'afficher les produits en vente.","Tu n'auras qu'à choisir."]
		],
		EN:[
			["Hi Gordon","What would you like?"],
			["Hello sir","I'd like to buy something."],
			["Here are the products I sell.","Just pick one."]
		]
	},

	TRAD_TREEVILLAGE_GORDONHOME:{
		FR:[
			["Bonjour Gordon."],
			["Bonjour Maman, comment va Papa ?"],
			["Il est encore mal en point...",
			"depuis la tempête qui a ravagé le puits...",
			"Le problème, c'est qu'en son absence,",
			"personne ne peut aider notre artisan",
			"à réparer notre unique puits...",
			]
		],
		EN:[
			["Hi Gordon."],
			["Hi Mom, how is Dad?"],
			["He is still not feeling well...",
			"since the storm that broke the well...",
			"The problem is, without him,",
			"nobody can help our craftsman",
			"repair our only well...",
			]
		]
	},

	TRAD_TREEVILLAGE_GORDONHOME_HEAL:{
		FR:["Tu as l'air épuisé, mon grand.","Mange un morceau et repose-toi un peu.","Voilà, tu es en pleine forme !"],
		EN:["You look exhausted, sweetie.","Eat something and rest a little.","There, you're as good as new!"]
	},

	#crab village

	TRAD_CRABVILLAGE:{
		FR:[
			[
				"Bonjour, jeune inconnu."
			],
			[
				"Bonjour,",
				"Il me faudrait des clous",
				"Pour réparer notre puits."
			],
			[
				"Tu es au bon endroit !",
				"Remporte nos 3 épreuves :",
				"Chacune te rapportera 2 gemmes,",
				"De quoi acheter des clous",
				"À la boutique."
			]
		],
		EN:[
			[
				"Hello, young stranger."
			],
			[
				"Hi,",
				"I need some nails",
				"To repair our well."
			],
			[
				"You've come to the right place!",
				"Win our 3 challenges:",
				"Each one gives you 2 gems,",
				"Enough to buy nails",
				"In the shop."
			]
		]

	},

	TRAD_CRABVILLAGE_GAME1_ALREADYWON:{
		FR:[
			"Re-bonjour,",
			"Désolé, mais tu as déjà gagné...",
			],
		EN:[
			"Hello again,",
			"Sorry, but you have already won...",
			]	
	},
	TRAD_CRABVILLAGE_GAME1_START:{
		FR:[
			"Bonjour, pour remporter ce jeu,",
			"Tu dois faire traverser",
			"Le crabe, l'algue et la méduse.",
			"Le radeau n'en porte qu'un à la fois.",
			"Attention si tu en laisses certains seuls :",
			"Le crabe mange la méduse,",
			"La méduse mange l'algue."
			],
		EN:[
			"Hi, to win this game",
			"You must take across",
			"The crab, the seaweed and the jellyfish.",
			"The raft can only carry one at a time.",
			"Careful, if you leave them alone:",
			"The crab eats the jellyfish,",
			"The jellyfish eats the seaweed."
			],

	},
	TRAD_CRABVILLAGE_GAME1_WIN:{
		FR:[
			"Félicitations, tu remportes ce jeu !",
			"Voici 2 gemmes en récompense."
			],
		EN:[
			"Congratulations, you win!",
			"Here are 2 gems."
			],

	},

	
	TRAD_CRABVILLAGE_GAME2_START:{
		FR:[
			"Dans cette énigme,",
			"Tu dois faire sortir",
			"La barque avec le crabe."
			],
		EN:[
			"In this puzzle,",
			"You must get the boat",
			"With the crab out."
			],
	},
	TRAD_CRABVILLAGE_GAME3_START:{
		FR:[
			"Dans cette énigme,",
			"Tu dois placer les coquillages",
			"Sur les emplacements avec des croix.",
			"Bloqué ? Appuie sur « Recommencer »."
			],
		EN:[
			"In this puzzle,",
			"You must put the shells",
			"On the spots marked with a cross.",
			"Stuck? Press \"Restart\"."
			],
	},
	TRAD_BEARVILLAGE_SHOP:{
		FR:[
			"Bonjour,",
			"Choisis parmi nos produits",
			"Celui de ton choix."
			],
		EN:[
			"Hello,",
			"Pick the product",
			"Of your choice."
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
		"Pick the product",
		"Of your choice."
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
			"Peux-tu m'aider à récupérer mon miel ?",
			"Va à la ruche et rapporte-moi mes 3 seaux de miel."
		],
		EN:[
			"Hi,",
			"Can you help me get my honey back?",
			"Go to the hive and bring me my 3 honey buckets."
		],
	},

	TRAD_BEARVILLAGE_BEEPLATFORM_WIN:{
		FR:[
			"Bravo,",
			"Merci beaucoup !",
			"Voilà 4 gemmes pour te remercier."
		],
		EN:[
			"Well done,",
			"Thanks a lot!",
			"Here are 4 gems to thank you."
		],

	},

	TRAD_BEARVILLAGE_BEEPLATFORM_REPLAY:{
		FR:[
			"Encore bravo !",
			"Mes seaux de miel sont bien à l'abri.",
			"Reviens jouer quand tu veux."
		],
		EN:[
			"Well done again!",
			"My honey buckets are safe now.",
			"Come back and play anytime."
		],
	},

	TRAD_BEARVILLAGE_BEVILROOM_START:{
		FR:[
			"Bonjour,",
			"Peux-tu m'aider ?",
			"Depuis quelques jours, de méchantes BeVil",
			"Nous empêchent d'accéder à la ruche."
		],
		EN:[
			"Hi,",
			"Can you help me?",
			"For a few days now, nasty BeVils",
			"Have been keeping us away from the hive."
		],

	},

	TRAD_BEARVILLAGE_BEVILROOM_WIN:{
		FR:[
			"Bravo,",
			"Un grand merci pour ton aide !",
			"Pour te remercier, voici 4 gemmes."
		],
		EN:[
			"Well done,",
			"Thanks a lot for your help!",
			"Here are 4 gems to thank you."
		],

	},

	TRAD_BEARVILLAGE_BEVILROOM_REPLAY:{
		FR:[
			"Bravo, encore une fois !",
			"Les BeVil n'osent plus approcher.",
			"Tu deviens un vrai guerrier !"
		],
		EN:[
			"Well done, once again!",
			"The BeVils don't dare come back.",
			"You're becoming a real warrior!"
		],
	},

	TRAD_TREEVILLAGE_STARFOUND:{
		FR:"Une étoile de Gormon trouvée ! (%d/%d)",
		EN:"Gormon star found! (%d/%d)",
		
	}


}

func _ready():
	loadLang()

func setLang(lang_):
	lang=lang_

# choix du joueur : appliqué et enregistré pour les prochains lancements
func chooseLang(lang_):
	setLang(lang_)
	var settings=ConfigFile.new()
	settings.load(SETTINGS_FILE)
	settings.set_value("game","lang",lang_)
	if settings.save(SETTINGS_FILE)!=OK:
		push_error("Erreur lors de l'ecriture de "+SETTINGS_FILE)

# langue enregistrée, sinon celle du système (anglais si elle n'est pas gérée)
func loadLang():
	var settings=ConfigFile.new()
	var defaultLang=FR if OS.get_locale_language()=="fr" else EN
	if settings.load(SETTINGS_FILE)==OK:
		setLang(settings.get_value("game","lang",defaultLang))
	else:
		setLang(defaultLang)

func toggleLang():
	chooseLang(EN if lang==FR else FR)

func getLang():
	return lang
	
func getTraductionById(id_):
	return traductionsList[id_][lang]

func getSceneToLoad():
	return _sceneToLoad

func create(nickname_):
	var scene='screens/tree-village/gordon-home.tscn'
	_filename=getNewFilename(nickname_)
	# une nouvelle partie ne doit rien garder de la partie precedente
	GlobalPlayer.reset()
	GlobalScenes.reset()
	GlobalPlayer.setNickname(nickname_)
	GlobalPlayer.savePosition(Vector2(48,75))
	save(scene)
	loadFile(_filename)

func saveWithPosition(scene_,position_):
	GlobalPlayer.savePosition(position_)
	save(scene_)

func save(scene_):
	var gameData=getDataToSave(scene_)
	var saveFile = FileAccess.open("user://"+_filename, FileAccess.WRITE)
	if saveFile == null:
		push_error("Erreur lors de l'ecriture de la sauvegarde user://"+_filename)
		return
	saveFile.store_line(JSON.stringify(gameData))
	saveFile.close()

func getNewFilename(nickname_):
	return getNewFilenameFromList(nickname_, getList())

# numero suivant le plus grand existant : ne jamais ecraser une partie
func getNewFilenameFromList(nickname_, saveList_):
	var filePattern=nickname_+"_"
	var newId=1
	for saveFile in saveList_:
		var number=saveFile.trim_prefix(filePattern).trim_suffix(".save")
		if saveFile.begins_with(filePattern) and number.is_valid_int():
			newId=max(newId, int(number)+1)
	return filePattern+str(newId)+".save"

# "BOB_2.save" s'affiche "BOB (2)"
func getSaveLabel(file_):
	var name=file_.trim_suffix(".save")
	var separator=name.rfind("_")
	if separator==-1:
		return name
	return name.substr(0, separator)+" ("+name.substr(separator+1)+")"

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

# fenetres de dialogue affichees : tant qu'il en reste une, Gordon ne bouge
# pas et n'utilise rien (il faut aller au bout du dialogue)
const DIALOG_GROUP="openDialog"

func isDialogOpen():
	return get_tree().get_first_node_in_group(DIALOG_GROUP)!=null


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
	
	GlobalPlayer.reset()
	GlobalScenes.reset()
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


	
