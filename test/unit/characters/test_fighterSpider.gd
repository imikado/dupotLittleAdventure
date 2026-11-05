extends GutTest

# animations de l'araignee de combat et du vol des BeVil

const SpiderFight=preload("res://screens/macro-map/spiderFight.gd")

const ANIMATIONS=["idle", "damage", "die", "attack-1"]
# image ou l'araignee se cabre : le "!" doit tomber dessus
const REAR_FRAME=3
const ATTACK_DURATION=1.5

var spider:Node2D
var frames:SpriteFrames
var beeFrames:SpriteFrames

func before_all():
	spider=load("res://common/fighters/spider1.tscn").instantiate()
	frames=spider.get_node("AnimatedSprite2D").sprite_frames
	var bee=load("res://common/moving-fighters/bee.tscn").instantiate()
	beeFrames=bee.get_node("AnimatedSprite2D").sprite_frames
	bee.free()

func after_all():
	spider.free()

# debut de l'image index_, en fraction de la duree de l'animation
func _frameStart(animation_, index_):
	var total=0.0
	var start=0.0
	for i in frames.get_frame_count(animation_):
		if i==index_:
			start=total
		total+=frames.get_frame_duration(animation_, i)
	return start/total

func test_animationsExistAndLoop():
	for animation in ANIMATIONS:
		assert_true(frames.has_animation(animation), animation)
		# la fin est detectee par animation_looped
		assert_true(frames.get_animation_loop(animation), animation)

func test_framesAre64x64():
	for animation in ANIMATIONS:
		for i in frames.get_frame_count(animation):
			assert_eq(frames.get_frame_texture(animation, i).get_size(), Vector2(64, 64), "%s %d" % [animation, i])

func test_attackKeepsItsTiming():
	assert_eq(frames.get_frame_count("attack-1"), 7)
	assert_almost_eq(spider.getAnimationDuration("attack-1"), ATTACK_DURATION, 0.001)

func test_signalFallsOnRearFrame():
	assert_lte(_frameStart("attack-1", REAR_FRAME), SpiderFight.SIGNAL_AT)
	assert_gt(_frameStart("attack-1", REAR_FRAME+1), SpiderFight.SIGNAL_AT)

func test_dieHoldsLastFrame():
	var last=frames.get_frame_count("die")-1
	for i in last:
		assert_almost_eq(frames.get_frame_duration("die", last), 3.0*frames.get_frame_duration("die", i), 0.001, "die %d" % i)

func test_idleBlinkIsShort():
	# le clignement est l'image la plus breve de la garde
	var shortest=INF
	for i in frames.get_frame_count("idle"):
		shortest=min(shortest, frames.get_frame_duration("idle", i))
	assert_lt(shortest, frames.get_frame_duration("idle", 0))

func test_beeFlapsFast():
	var count=beeFrames.get_frame_count("default")
	assert_between(count, 4, 6)
	assert_between(beeFrames.get_animation_speed("default"), 10.0, 12.0)
	assert_true(beeFrames.get_animation_loop("default"))
	for i in count:
		assert_eq(beeFrames.get_frame_texture("default", i).get_size(), Vector2(32, 32), "bee %d" % i)
