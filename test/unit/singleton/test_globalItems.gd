extends GutTest

var Items=load("res://common/singletons/globalItems.gd")
var itemClass=load("res://common/class/item_class.gd")

var items=null

func before_each():
	items=Items.new()

func after_each():
	items.free()

# meilleure attaque d'une arme parmi celles accessibles avec cette xp
func _getBestDamage(item_, xp_):
	var bestDamage=0
	for attack in item_.actionList:
		if attack.xpMin <= xp_:
			bestDamage=max(bestDamage, attack.damage)
	return bestDamage

func test_idsDoNotMove():
	# les sauvegardes stockent les numeros : l'epee en fer est ajoutee a la fin
	assert_eq(0, Items.ID.WOOD_SWORD, "l'epee en bois garde son numero")
	assert_eq(7, Items.ID.BUCKET, "le seau garde son numero")
	assert_eq(8, Items.ID.IRON_SWORD, "l'epee en fer vient apres le seau")

func test_ironSwordIsWeapon():
	var ironSword=items.getItem(Items.ID.IRON_SWORD)
	assert_not_null(ironSword, "l'epee en fer existe")
	assert_eq(itemClass.TYPE.WEAPON, ironSword.type, "c'est une arme")
	assert_true(items.isWeapon(Items.ID.IRON_SWORD))
	assert_true(items.isWeapon(Items.ID.WOOD_SWORD))
	assert_false(items.isWeapon(Items.ID.SPADE), "la pelle n'est pas une arme")
	assert_false(items.isWeapon(null), "rien en main")
	assert_true(ResourceLoader.exists("res://"+ironSword.image), "l'icone existe")

func test_weaponIdList():
	assert_eq([Items.ID.WOOD_SWORD, Items.ID.IRON_SWORD], items.getWeaponIdList())

func test_ironSwordAnimations():
	# noms d'animation attendus par common/fighters/player.tscn
	var animationList=[]
	for attack in items.getItem(Items.ID.IRON_SWORD).actionList:
		animationList.append(attack.animation)
	assert_eq(["attack_iron-sword_simple", "attack_iron-sword_legend"], animationList)

func test_ironSwordHitsHarderThanWoodSword():
	# chaque attaque de l'epee en fer bat les attaques de l'epee en bois
	# disponibles au meme niveau d'xp (xpMin)
	var woodSword=items.getItem(Items.ID.WOOD_SWORD)
	var ironSword=items.getItem(Items.ID.IRON_SWORD)
	for attack in ironSword.actionList:
		assert_gt(attack.damage, _getBestDamage(woodSword, attack.xpMin), "%s a xp %d" % [attack.animation, attack.xpMin])
	# attaque de base contre attaque de base
	assert_gt(ironSword.actionList[0].damage, woodSword.actionList[0].damage)

func test_ironSwordAlwaysBest():
	# epee de legende : a tout niveau d'xp, son meilleur coup bat celui de l'epee en bois
	var woodSword=items.getItem(Items.ID.WOOD_SWORD)
	var ironSword=items.getItem(Items.ID.IRON_SWORD)
	for xp in range(0, 101):
		assert_gt(_getBestDamage(ironSword, xp), _getBestDamage(woodSword, xp), "a xp %d" % xp)
