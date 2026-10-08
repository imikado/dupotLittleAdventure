extends CanvasLayer

# Changement de scene avec fondu au noir par paliers (style pixel art)

const STEPS=[0.25, 0.5, 0.75, 1.0]
const STEP_DURATION=0.04

var _rect:ColorRect
var _busy=false

func _ready():
	layer=100
	process_mode=Node.PROCESS_MODE_ALWAYS
	_rect=ColorRect.new()
	_rect.color=Color(0.07, 0.06, 0.1, 0.0)
	_rect.mouse_filter=Control.MOUSE_FILTER_IGNORE
	_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(_rect)

func isBusy():
	return _busy

func change_scene(path_):
	if _busy:
		return
	_busy=true
	# on fige le jeu pendant le fondu (evite de declencher une autre porte)
	get_tree().paused=true
	_rect.mouse_filter=Control.MOUSE_FILTER_STOP
	await _fade(STEPS)
	get_tree().paused=false
	get_tree().change_scene_to_file(path_)
	await get_tree().scene_changed
	var reversed=STEPS.duplicate()
	reversed.reverse()
	await _fade(reversed.slice(1)+[0.0])
	_rect.mouse_filter=Control.MOUSE_FILTER_IGNORE
	_busy=false

func _fade(alphaList_):
	for alpha in alphaList_:
		_rect.color.a=alpha
		await get_tree().create_timer(STEP_DURATION, true).timeout
