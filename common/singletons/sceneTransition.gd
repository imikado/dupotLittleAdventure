extends CanvasLayer

# Changement de scene facon 16 bits : l'image se pixelise (effet mosaique)
# en s'assombrissant par paliers, puis l'inverse sur la nouvelle scene

const STEPS=[0.15, 0.3, 0.5, 0.7, 0.85, 1.0]
const STEP_DURATION=0.045
# taille des blocs de la mosaique (en pixels du jeu) pour chaque palier
const MOSAIC_MAX=12
const DARK=Color(0.07, 0.06, 0.1)

const MOSAIC_SHADER="""
shader_type canvas_item;
uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;
uniform vec2 base_size = vec2(320.0, 180.0);
uniform float block = 1.0;
uniform float darkness = 0.0;
uniform vec3 dark_color = vec3(0.0);
void fragment() {
	vec2 blocks = base_size / max(block, 1.0);
	vec2 uv = (floor(SCREEN_UV * blocks) + 0.5) / blocks;
	vec3 color = texture(screen_texture, uv).rgb;
	COLOR = vec4(mix(color, dark_color, darkness), 1.0);
}
"""

var _rect:ColorRect
var _material:ShaderMaterial
var _busy=false

func _ready():
	layer=100
	process_mode=Node.PROCESS_MODE_ALWAYS
	var shader=Shader.new()
	shader.code=MOSAIC_SHADER
	_material=ShaderMaterial.new()
	_material.shader=shader
	_material.set_shader_parameter("base_size", Vector2(
		ProjectSettings.get_setting("display/window/size/viewport_width"),
		ProjectSettings.get_setting("display/window/size/viewport_height")))
	_material.set_shader_parameter("dark_color", Vector3(DARK.r, DARK.g, DARK.b))
	_rect=ColorRect.new()
	_rect.material=_material
	_rect.visible=false
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
	_rect.visible=true
	await _fade(STEPS)
	get_tree().paused=false
	get_tree().change_scene_to_file(path_)
	await get_tree().scene_changed
	var reversed=STEPS.duplicate()
	reversed.reverse()
	await _fade(reversed.slice(1)+[0.0])
	_rect.visible=false
	_rect.mouse_filter=Control.MOUSE_FILTER_IGNORE
	_busy=false

func _fade(stepList_):
	for step in stepList_:
		_material.set_shader_parameter("darkness", step)
		_material.set_shader_parameter("block", 1.0+step*(MOSAIC_MAX-1))
		await get_tree().create_timer(STEP_DURATION, true).timeout
