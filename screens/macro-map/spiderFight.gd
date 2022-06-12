extends Node2D

var lifeSpider=50
var damageSpider=10

var itemClass=preload("res://common/class/item_class.gd")
var attackClass=preload("res://common/class/item/attack_class.gd")

var positionToGoUp
var positionToGoDown

const UP="UP"
const DOWN="DOWN"

func debug():
	GlobalPlayer.savePosition( Vector2(20,260)) 
	
	GlobalPlayer.addItem(itemClass.new(
			"Epée en bois",
			"Une simple épée en bois de hêtre",
			"common/items/weapons/wood-sword.png",
			itemClass.TYPE.WEAPON,
			[
				attackClass.new(
					"Attaque simple",
					"attack_wood-sword_simple",
					50,
					0
				),
				attackClass.new(
					"Attaque avancée",
					"attack_wood-sword_advanced",
					20,
					10
				),
				attackClass.new(
					"Attaque en feu",
					"attack_wood-sword_onfire",
					50,
					50
				)
			]
			) 
		)
	$gamepad.build()
	
func debug2():
	GlobalPlayer.addItemEvenIfExist(GlobalItems.ID.WOOD_SWORD)
	$gamepad.rebuild()


# Called when the node enters the scene tree for the first time.
func _ready():
	#debug2()

	$lifePlayer.init(GlobalPlayer.getLife(),GlobalPlayer.getMaxLife())
	$lifeSpider.init(lifeSpider,lifeSpider)

	positionToGoUp=Vector2( GlobalPlayer.getPosition().x,260)  
	positionToGoDown=Vector2( GlobalPlayer.getPosition().x,420)
	
 

func _on_gamepad_attack(attack_):
	$player.playAttack(attack_.animation)
	lifeSpider-=attack_.damage
	
	$gamepad.hide()

	
func _on_player_attackFinished():
	$spider1.playDamage()

func _on_spider1_damageFinished():
	$lifeSpider.updateValue(lifeSpider)
	if lifeSpider <=0:
		$spider1.playDie()
	else:
		$spider1.playAttack("attack-1")
		GlobalPlayer.damage(damageSpider)

func _on_spider1_attackFinished():
	$player.playDamage()

func _on_player_damageFinished():
	$lifePlayer.updateValue(GlobalPlayer.getLife())
	
	$gamepad.show()

func _on_spider1_dieFinished():
	GlobalPlayer.addXp(1)
	if(GlobalPlayer.getSide()==UP):
		GlobalPlayer.savePosition(positionToGoDown )
	else:
		GlobalPlayer.savePosition(positionToGoUp )
		
	get_tree().change_scene("res://screens/macro-map.tscn")


func _on_player_dieFinished():	
	get_tree().change_scene("res://screens/game-over.tscn")


func _on_gamepad_leave():
	if(GlobalPlayer.getSide()==UP):
		GlobalPlayer.savePosition(positionToGoUp )
	else:
		GlobalPlayer.savePosition(positionToGoDown )
		
	get_tree().change_scene("res://screens/macro-map.tscn")

