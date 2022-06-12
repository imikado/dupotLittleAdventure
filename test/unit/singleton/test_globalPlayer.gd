extends "res://addons/gut/test.gd"

class TestSimpleProperties:
	extends 'res://addons/gut/test.gd'
	var Player=load("res://common/singletons/globalPlayer.gd")
	
	func test_life():
		#Arrange
		var player=Player.new()
		#Act
		player.setLife(100)
		player.damage(20)
		var lifeLeft=player.getLife()
		#Assert
		var expectedLifeLeft=80
		assert_eq(expectedLifeLeft, lifeLeft, "devrait afficher 80: 100-20")

	func test_xp():
		#Arrange
		var player=Player.new()
		#Act
		player.setXp(20)
		player.addXp(10)
		var newXp=player.getXp()
		#Assert
		var expectedNewXp=30
		assert_eq(expectedNewXp,newXp,"devrait afficher 30: 20+10")
		
		#Act 2
		var life=player.getLife()
		#Assert
		var expectedLife=100
		assert_eq(expectedLife,life,"devrait etre a 100 (confirme l'isolation des tests)")


class TestLittleIntelligence:
	extends 'res://addons/gut/test.gd'
	var Player=load("res://common/singletons/globalPlayer.gd")
	
	func test_savePosition():
		var player=Player.new()
		player.savePosition(Vector2(10,50))
		var savedPosition=player.getPosition()
		player.queue_free()
		assert_eq(Vector2(10,50),savedPosition)

		
	func test_loadPosition():
		var player=Player.new()
		player.savePosition(Vector2(10,50))
		var savedPosition=player.loadPosition()
		assert_eq(Vector2(10,50),savedPosition,"devrait retourner les coord")
		var savedPositionAfterLoad=player.loadPosition()
		assert_eq(null,savedPositionAfterLoad,"devrait retourner vide")
	
	func test_shouldLoadPosition():
		var player=Player.new()
		assert_false(player.shouldLoadPosition(),"doit retourner faux car pas de position")
		player.savePosition(Vector2(10,50))	
		assert_true(player.shouldLoadPosition(),"devrait retourner vrai car une position a ete sauvée")
		player.resetPosition()
		assert_false(player.shouldLoadPosition(),"devrait retourner faux car la position a ete effacée")
		
	func test_items():
		#Arrange
		var player=Player.new()
		#Act
		player.addItem(4)
		#Assert
		assert_eq([4],player.getItemsList(),"devrait afficher [4]")
		assert_eq(true,player.hasItem(4),"devrait afficher true")
		
		player.addItemIfNotExist(4)
		
		assert_eq([4],player.getItemsList(),"devrait toujours afficher [4]")
		
