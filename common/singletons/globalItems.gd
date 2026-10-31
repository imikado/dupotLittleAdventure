extends Node

var itemClass=preload("res://common/class/item_class.gd")
var attackClass=preload("res://common/class/item/attack_class.gd")
var potionClass=preload("res://common/class/item/potion_class.gd")

enum ID {
	#weapons
	WOOD_SWORD,
	#potions 
	HEALTH_POTION_10,
	#maps
	GORMON_STAR_MAP,
	#tools
	SPADE,
	
	#things
	GORDMON_STAR,
	
	NAILS,

	HONEY,

	BUCKET
	
	}

# noms et descriptions en FR/EN : lus via getName() / getDescription()
var itemList={
	
	ID.WOOD_SWORD:itemClass.new(
		{GlobalGame.FR:"Épée en bois",GlobalGame.EN:"Wooden sword"},
		{GlobalGame.FR:"Une simple épée en bois de hêtre",GlobalGame.EN:"A simple beech wood sword"},
		"common/items/weapons/wood-sword.png",
		itemClass.TYPE.WEAPON,
		[
			attackClass.new(
				{GlobalGame.FR:"Attaque simple",GlobalGame.EN:"Simple attack"},
				"attack_wood-sword_simple",
				10,
				0
			),
			attackClass.new(
				{GlobalGame.FR:"Attaque avancée",GlobalGame.EN:"Advanced attack"},
				"attack_wood-sword_advanced",
				20,
				10
			),
			attackClass.new(
				{GlobalGame.FR:"Attaque en feu",GlobalGame.EN:"Fire attack"},
				"attack_wood-sword_onfire",
				50,
				50
			)
		]
	),
	ID.HEALTH_POTION_10:itemClass.new(
		{GlobalGame.FR:"Potion de santé",GlobalGame.EN:"Health potion"},
		{GlobalGame.FR:"Une potion de santé qui donne 10 points de vie.",GlobalGame.EN:"A health potion that restores 10 life points."},
		"common/items/magicpotion/magic-potion.png",
		itemClass.TYPE.MAGICPOTION,
		[	
			potionClass.new("increaseLife",10)
		]
	),
	ID.SPADE:itemClass.new(
		{GlobalGame.FR:"Pelle",GlobalGame.EN:"Spade"},
		{GlobalGame.FR:"Une pelle pour creuser",GlobalGame.EN:"A spade for digging"},
		"common/items/tools/spade.png",
		itemClass.TYPE.TOOL
	),
	ID.GORMON_STAR_MAP:itemClass.new(
		{GlobalGame.FR:"Carte",GlobalGame.EN:"Map"},
		{GlobalGame.FR:"Carte au trésor des étoiles de Gormon",GlobalGame.EN:"Treasure map of the Gormon stars"},
		"common/items/maps/gormon-star-map.png",
		itemClass.TYPE.MAP
	),
	ID.GORDMON_STAR:itemClass.new(
		{GlobalGame.FR:"Étoile",GlobalGame.EN:"Star"},
		{GlobalGame.FR:"Étoile de Gormon",GlobalGame.EN:"Gormon star"},
		"common/items/things/gordon-star.png",
		itemClass.TYPE.THING
	),
	ID.NAILS:itemClass.new(
		{GlobalGame.FR:"Clous",GlobalGame.EN:"Nails"},
		{GlobalGame.FR:"Clous pour le puits",GlobalGame.EN:"Nails for the well"},
		"common/items/things/nails.png",
		itemClass.TYPE.THING
	),
	ID.HONEY:itemClass.new(
		{GlobalGame.FR:"Miel",GlobalGame.EN:"Honey"},
		{GlobalGame.FR:"Miel pour réparer le puits",GlobalGame.EN:"Honey to repair the well"},
		"common/items/things/honey.png",
		itemClass.TYPE.THING
	),
	ID.BUCKET:itemClass.new(
		{GlobalGame.FR:"Seau",GlobalGame.EN:"Bucket"},
		{GlobalGame.FR:"Seau pour le puits",GlobalGame.EN:"Bucket for the well"},
		"common/items/things/bucket.png",
		itemClass.TYPE.THING
	)
}

func getItem(key_):
	return itemList[int(key_)]
	
	


