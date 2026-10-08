extends GutTest

var FightRules=load("res://common/class/fight_rules.gd")

func test_damageStaysInVarianceRange():
	var rng=RandomNumberGenerator.new()
	rng.seed=42
	for i in 200:
		var roll=FightRules.rollDamage(10, rng, false)
		assert_false(roll.critical, "pas de critique quand ils sont desactives")
		assert_between(roll.damage, 8, 12, "10 +/- 20%")

func test_criticalDoublesDamage():
	var rng=RandomNumberGenerator.new()
	rng.seed=1
	var criticalCount=0
	for i in 500:
		var roll=FightRules.rollDamage(10, rng)
		if roll.critical:
			criticalCount+=1
			assert_between(roll.damage, 16, 24, "un critique double les degats")
	assert_between(criticalCount, 20, 90, "environ 10% de critiques")

func test_damageIsAtLeastOne():
	var rng=RandomNumberGenerator.new()
	rng.seed=7
	for i in 50:
		assert_gte(FightRules.rollDamage(0, rng).damage, 1)

func test_enemySometimesMisses():
	var rng=RandomNumberGenerator.new()
	rng.seed=3
	var missCount=0
	for i in 500:
		if !FightRules.rollEnemyHit(rng):
			missCount+=1
	assert_between(missCount, 40, 120, "environ 15% d'attaques ratees")
