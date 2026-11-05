extends GutTest

# Portraits des dialogues : choix selon le nom affiche, la scene et la replique

var SimpleDialog=load("res://common/ui/simpleDialog.gd")
var dialog

func before_each():
	dialog=SimpleDialog.new()
	GlobalGame.setLang(GlobalGame.FR)

func after_each():
	dialog.free()

func after_all():
	GlobalGame.setLang(GlobalGame.FR)

func test_portraitParNom():
	var talker=GlobalGame.getTraductionById(GlobalGame.TRAD_WORD_GORDONMOM)
	assert_eq(dialog.getPortraitName(talker, ""), "mom")

func test_portraitParNomEnAnglais():
	GlobalGame.setLang(GlobalGame.EN)
	var talker=GlobalGame.getTraductionById(GlobalGame.TRAD_WORD_ARTISAN)
	assert_eq(dialog.getPortraitName(talker, ""), "craftsman")

func test_vendeurSelonLaBoutique():
	var talker=GlobalGame.getTraductionById(GlobalGame.TRAD_WORD_VENDEUR)
	assert_eq(dialog.getPortraitName(talker, "res://screens/tree-village/shop.tscn"), "seller")
	assert_eq(dialog.getPortraitName(talker, "res://screens/tree-village/gem-house.tscn"), "gemSeller")
	assert_eq(dialog.getPortraitName(talker, "res://screens/bear-village/shop.tscn"), "bearSeller")
	assert_eq(dialog.getPortraitName(talker, "res://screens/crabs-village/shop.tscn"), "crab")

func test_personnageInconnuSansPortrait():
	assert_eq(dialog.getPortraitName("Inconnu", ""), "")
	assert_eq(dialog.getPortraitPath("Inconnu", "Bonjour !", ""), "")

func test_expressionContenteSurUneExclamation():
	var talker=GlobalGame.getTraductionById(GlobalGame.TRAD_WORD_GORDON)
	assert_eq(dialog.getPortraitPath(talker, "Merci !", ""), "res://common/ui/portraits/gordon-happy.png")
	assert_eq(dialog.getPortraitPath(talker, "Bonjour.", ""), "res://common/ui/portraits/gordon.png")

func test_tousLesPortraitsExistent():
	var names=dialog.getPortraitByTalker().values()
	for scene in dialog.getPortraitByScene().values():
		names.append_array(scene.values())
	for portraitName in names:
		for suffix in ["", "-happy"]:
			var path=dialog.PORTRAIT_DIR+portraitName+suffix+".png"
			assert_true(ResourceLoader.exists(path), path)
