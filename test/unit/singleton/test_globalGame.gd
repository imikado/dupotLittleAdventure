extends GutTest

var Game=load("res://common/singletons/globalGame.gd")

func test_getFilteredSaveList():
	
	#Arrange
	var fileList=[
		"mika_1.save",
		"otherFile.txt",
		"other_systemFile.sh"
	]
	
	var game=autofree(Game.new())
	var filterSaveList=game.getFilteredSaveList(fileList)
	
	assert_eq(["mika_1.save"],filterSaveList,"we should have only mika_1")

func test_getNewFilenameFromList():
	var game=autofree(Game.new())
	# "BOBBY" ne compte pas pour "BOB", et un trou dans la numerotation n'ecrase rien
	var saveList=["BOB_1.save", "BOB_3.save", "BOBBY_7.save"]
	assert_eq("BOB_4.save", game.getNewFilenameFromList("BOB", saveList), "suite du plus grand numero de BOB")
	assert_eq("ANNE_1.save", game.getNewFilenameFromList("ANNE", saveList), "premiere partie d'ANNE")
	game.free()

func test_getSaveLabel():
	var game=autofree(Game.new())
	assert_eq("BOB (2)", game.getSaveLabel("BOB_2.save"), "nom lisible de la sauvegarde")
	assert_eq("JEAN-LUC (1)", game.getSaveLabel("JEAN-LUC_1.save"), "le tiret du pseudo est garde")
	game.free()
