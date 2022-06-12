extends "res://addons/gut/test.gd"

var Game=load("res://common/singletons/globalGame.gd")

func test_getFilteredSaveList():
	
	#Arrange
	var fileList=[
		"mika_1.save",
		"otherFile.txt",
		"other_systemFile.sh"
	]
	
	var game=Game.new()
	var filterSaveList=game.getFilteredSaveList(fileList)
	
	assert_eq(["mika_1.save"],filterSaveList,"we should have only mika_1")
