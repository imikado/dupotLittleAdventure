extends RefCounted

# Regles du combat au tour par tour (sans etat, testables)

const DAMAGE_VARIANCE=0.2
const CRITICAL_CHANCE=0.1
const CRITICAL_MULTIPLIER=2
const ENEMY_MISS_CHANCE=0.15
const FLEE_CHANCE=0.75

# degats d'une attaque : +/- 20% autour de la valeur de base, avec une chance de coup critique
static func rollDamage(baseDamage_, rng_:RandomNumberGenerator, canBeCritical_=true):
	var damage=int(round(baseDamage_*rng_.randf_range(1.0-DAMAGE_VARIANCE, 1.0+DAMAGE_VARIANCE)))
	var critical=canBeCritical_ and rng_.randf() < CRITICAL_CHANCE
	if critical:
		damage*=CRITICAL_MULTIPLIER
	return {"damage":max(1, damage), "critical":critical}

static func rollEnemyHit(rng_:RandomNumberGenerator):
	return rng_.randf() >= ENEMY_MISS_CHANCE

static func rollFlee(rng_:RandomNumberGenerator):
	return rng_.randf() < FLEE_CHANCE
