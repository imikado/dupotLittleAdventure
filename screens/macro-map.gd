extends "res://common/class/scene.gd"

# Carte du monde : les lieux sont des etapes reliees par des chemins.
# Une direction fait filer Gordon jusqu'a l'etape suivante, "accepter" entre
# dans le village. La toile des araignees coupe la route du nord : la
# traverser declenche un combat (comme sur l'ancienne carte).

# etapes (en pixels de la carte, 320x180)
const TREE=Vector2(62,140)
const SPIDER_SOUTH=Vector2(150,134)
const SPIDER_NORTH=Vector2(172,98)
const BEAR=Vector2(100,66)
const CRABS=Vector2(250,64)

# chemins entre deux etapes, points intermediaires compris
const PATHS=[
	[TREE, Vector2(100,146), Vector2(130,138), SPIDER_SOUTH],
	[SPIDER_SOUTH, Vector2(160,122), Vector2(164,110), SPIDER_NORTH],
	[SPIDER_NORTH, Vector2(150,90), Vector2(124,80), BEAR],
	[SPIDER_NORTH, Vector2(200,92), Vector2(228,76), CRABS],
]
# le chemin barre par la toile (index dans PATHS)
const SPIDER_PATH=1
# un chemin est une courbe qui passe par ses points : roads.gd la peint et
# Gordon la suit (PATH_SAMPLES points par troncon)
const PATH_SAMPLES=8

# apres une victoire, l'araignee laisse passer Gordon quelques fois
const SPIDER_REST_KEY="spiderRest"
const SPIDER_REST_CROSSINGS=2
const WEB_RESTING_ALPHA=0.4

# fanion plante a cote du socle d'un village dont on a rapporte les objets
const FLAG_TEXTURE=preload("res://screens/macro-map/images/world/flag-done.png")
const FLAG_OFFSET=Vector2(10,-4)

const SPEED=120.0
# une direction doit viser le chemin d'assez pres pour le choisir
const MIN_ALIGNMENT=0.4
const JOYSTICK_DEAD_ZONE=10

var places={}
var current=TREE
var route=[]
var routeIndex=0
var crossingWeb=false
var webPassed=false
var joystick=Vector2.ZERO
# une direction encore tenue en sortant d'un village ne fait pas repartir
# Gordon : il faut d'abord la relacher
var waitRelease=true

@onready var gordon=$gordon
@onready var gordonSprite=$gordon/sprite

func _ready():
	setPlayerPath("playerAndControl")
	places={
		TREE:{"name":GlobalGame.TRAD_MAP_TREEVILLAGE, "scene":"res://screens/tree-village.tscn", "entry":Vector2(900,258)},
		CRABS:{"name":GlobalGame.TRAD_MAP_CRABVILLAGE, "scene":"res://screens/crabs-village.tscn", "entry":Vector2(79,168)},
		BEAR:{"name":GlobalGame.TRAD_MAP_BEARVILLAGE, "scene":"res://screens/bear-village.tscn", "entry":Vector2(964,427)},
		SPIDER_SOUTH:{"name":GlobalGame.TRAD_MAP_SPIDERWEB},
		SPIDER_NORTH:{"name":GlobalGame.TRAD_MAP_SPIDERWEB},
	}
	# le joueur "classique" ne sert qu'au HUD et a la sauvegarde : on le cache
	var player=getPlayer().get_node("player")
	player.visible=false
	player.process_mode=Node.PROCESS_MODE_DISABLED
	getPlayer().disableCamera()
	$camera.make_current()
	gordonSprite.sprite_frames=_gordonFrames()
	var navigation=getPlayer().get_node("navigation")
	navigation.movePlayer.connect(func(vector_): joystick=vector_)
	navigation.pushButton.connect(_enter)
	$placeInfo/panel/enter.pressed.connect(_enter)

	if GlobalPlayer.shouldLoadPosition():
		current=_nearestPlace(GlobalPlayer.loadPosition())
	_refreshWeb()
	_showCompletedFlags()
	_arrive(current)

func _nearestPlace(position_):
	var best=TREE
	for place in places:
		if place.distance_to(position_) < best.distance_to(position_):
			best=place
	return best

#--- deplacements

func _process(delta):
	if getPlayer().get_node("HUD").isMenuOpen():
		return
	if route.is_empty():
		var direction=_inputDirection()
		if waitRelease:
			waitRelease=direction!=Vector2.ZERO
			return
		_chooseRoute(direction)
	else:
		_travel(delta)

func _inputDirection():
	var direction=Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction==Vector2.ZERO and joystick.length() > JOYSTICK_DEAD_ZONE:
		direction=joystick.normalized()
	return direction

# part sur le chemin qui va le mieux dans la direction demandee
func _chooseRoute(direction_):
	if direction_==Vector2.ZERO:
		return
	var best=[]
	var bestAlignment=MIN_ALIGNMENT
	var bestIndex=-1
	for index in PATHS.size():
		var path=PATHS[index]
		var points=[]
		if path[0]==current:
			points=path.duplicate()
		elif path[-1]==current:
			points=path.duplicate()
			points.reverse()
		else:
			continue
		var alignment=(points[1]-points[0]).normalized().dot(direction_.normalized())
		if alignment > bestAlignment:
			bestAlignment=alignment
			best=points
			bestIndex=index
	if best.is_empty():
		return
	route=smoothPath(best)
	routeIndex=1
	crossingWeb=bestIndex==SPIDER_PATH
	webPassed=false
	$placeInfo.visible=false

# courbe de Catmull-Rom passant par les points du chemin ; les points de
# depart et d'arrivee restent exacts (ce sont les cles de places)
static func smoothPath(path_):
	var points=[path_[0]]
	for i in path_.size()-1:
		var before=path_[i-1] if i > 0 else path_[i]
		var after=path_[i+2] if i+2 < path_.size() else path_[i+1]
		for k in range(1, PATH_SAMPLES):
			points.append(path_[i].cubic_interpolate(path_[i+1], before, after, float(k)/PATH_SAMPLES))
		points.append(path_[i+1])
	return points

func _travel(delta):
	var step=SPEED*delta
	while step > 0 and !route.is_empty():
		var target=route[routeIndex]
		var toTarget=target-gordon.position
		if toTarget.length() <= step:
			gordon.position=target
			step-=toTarget.length()
			routeIndex+=1
			if routeIndex >= route.size():
				_arrive(target)
				return
		else:
			gordon.position+=toTarget.normalized()*step
			step=0
		_animateWalk(toTarget)
	if crossingWeb and !webPassed and gordon.position.distance_to($web.position) < 3:
		webPassed=true
		var rest=getSpiderRest()
		if rest > 0:
			# l'araignee se repose : la toile est libre
			setSpiderRest(rest-1)
			_refreshWeb()
		else:
			_startSpiderFight()

func _arrive(place_):
	route=[]
	current=place_
	gordon.position=place_
	gordonSprite.play("idle")
	# position lue par la sauvegarde du HUD
	getPlayer().get_node("player").global_position=place_
	_showPlaceInfo()

# animations de Gordon taillees dans les planches du personnage (32x32)
func _gordonFrames():
	var frames=SpriteFrames.new()
	frames.remove_animation("default")
	var sheets={
		# respiration puis clignement bref : chaque image a sa propre duree
		"idle":["res://common/characters/player/Player-idle.png", 8.0, [6, 6, 10, 1]],
		"walk-right":["res://common/characters/player/Player-walking-right.png", 12.0],
		"walk-down":["res://common/characters/player/Player-walking-down.png", 12.0],
		"walk-up":["res://common/characters/player/Player-walking-up.png", 12.0],
	}
	for animation in sheets:
		var texture:Texture2D=load(sheets[animation][0])
		frames.add_animation(animation)
		frames.set_animation_speed(animation, sheets[animation][1])
		for i in texture.get_width()/32:
			var atlas=AtlasTexture.new()
			atlas.atlas=texture
			atlas.region=Rect2(i*32, 0, 32, 32)
			var duration=sheets[animation][2][i] if sheets[animation].size() > 2 else 1.0
			frames.add_frame(animation, atlas, duration)
	return frames

func _animateWalk(direction_):
	if abs(direction_.x) >= abs(direction_.y):
		gordonSprite.play("walk-right")
		gordonSprite.flip_h=direction_.x < 0
	elif direction_.y < 0:
		gordonSprite.play("walk-up")
		gordonSprite.flip_h=true
	else:
		gordonSprite.play("walk-down")
		gordonSprite.flip_h=false

#--- lieux

# cadre en bas de l'ecran : nom du lieu (et bouton "Entrer" pour un village),
# a la largeur du texte et centre
const INFO_MARGIN=6
func _showPlaceInfo():
	var place=places[current]
	var panel=$placeInfo/panel
	var label=$placeInfo/panel/name
	var button=$placeInfo/panel/enter
	label.text=GlobalGame.getTraductionById(place.name)
	label.size=label.get_minimum_size()
	var width=INFO_MARGIN+label.size.x+INFO_MARGIN
	button.visible=place.has("scene")
	if button.visible:
		button.text=GlobalGame.getTraductionById(GlobalGame.TRAD_MAP_ENTER)
		button.size=button.get_minimum_size()
		button.position.x=width
		width+=button.size.x+INFO_MARGIN-2
	panel.size.x=width
	panel.position.x=round((get_viewport_rect().size.x-width)/2)
	$placeInfo.visible=true

func _unhandled_input(event):
	if getPlayer().get_node("HUD").isMenuOpen():
		return
	if event.is_action_pressed("ui_accept"):
		_enter()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("ui_cancel"):
		getPlayer().get_node("HUD").openPauseMenu()
		get_viewport().set_input_as_handled()

func _enter():
	if !route.is_empty() or SceneTransition.isBusy() or !places[current].has("scene"):
		return
	Sfx.play(Sfx.CONFIRM)
	GlobalPlayer.savePosition(places[current].entry)
	SceneTransition.change_scene(places[current].scene)

# l'araignee attaque sur la toile ; le combat renvoie de l'autre cote
# (victoire) ou au point de depart (fuite, defaite)
func _showCompletedFlags():
	var completedList={
		CRABS:GlobalPlayer.hasItem(GlobalItems.ID.NAILS),
		BEAR:GlobalPlayer.hasItem(GlobalItems.ID.HONEY) and GlobalPlayer.hasItem(GlobalItems.ID.BUCKET),
	}
	for place in completedList:
		if completedList[place]:
			var flag=Sprite2D.new()
			flag.texture=FLAG_TEXTURE
			flag.position=place+FLAG_OFFSET
			add_child(flag)
			move_child(flag, $gordon.get_index())

static func getSpiderRest():
	return GlobalScenes.getParamForSceneOr("res://screens/macro-map.tscn", SPIDER_REST_KEY, 0)

static func setSpiderRest(crossings_):
	GlobalScenes.saveParamForScene("res://screens/macro-map.tscn", SPIDER_REST_KEY, crossings_)

# toile estompee tant que l'araignee se repose
func _refreshWeb():
	$web.modulate.a=WEB_RESTING_ALPHA if getSpiderRest() > 0 else 1.0

func _startSpiderFight():
	var fromSouth=route[-1]==SPIDER_NORTH
	GlobalPlayer.setSide("DOWN" if fromSouth else "UP")
	set_process(false)
	SceneTransition.change_scene("res://screens/macro-map/spiderFight.tscn")
