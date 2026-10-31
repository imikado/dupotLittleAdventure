extends Node2D

# Logo "Little Adventure" en police pixel : une etiquette par lettre,
# qui tombent en rebondissant (intro) puis ondulent doucement

const FONT=preload("res://common/themes/fonts/pixelOperator8-bold.ttf")
const COLOR_LETTER=Color(1, 0.82, 0.4)
const COLOR_OUTLINE=Color(0.24, 0.14, 0.07)
const COLOR_SHADOW=Color(0.1, 0.06, 0.02, 0.55)

# [texte, taille, decalage de la ligne]
const LINES=[["Little", 16, Vector2(0, 0)], ["Adventure", 24, Vector2(24, 20)]]

const WAVE_SPEED=3.0
const WAVE_AMPLITUDE=1.5
const DROP_HEIGHT=80
const DROP_STAGGER=0.05

var _letters=[]

func _ready():
	var index=0
	for line in LINES:
		var x=line[2].x
		for character in line[0]:
			var label=_makeLetter(character, line[1])
			label.position=Vector2(x, line[2].y)
			x+=FONT.get_string_size(character, HORIZONTAL_ALIGNMENT_LEFT, -1, line[1]).x
			_letters.append({"label":label, "restY":line[2].y, "phase":index*0.5})
			index+=1

func _makeLetter(character_, size_):
	var label=Label.new()
	label.text=character_
	label.add_theme_font_override("font", FONT)
	label.add_theme_font_size_override("font_size", size_)
	label.add_theme_color_override("font_color", COLOR_LETTER)
	label.add_theme_color_override("font_outline_color", COLOR_OUTLINE)
	label.add_theme_constant_override("outline_size", size_/4)
	label.add_theme_color_override("font_shadow_color", COLOR_SHADOW)
	label.add_theme_constant_override("shadow_offset_x", 0)
	label.add_theme_constant_override("shadow_offset_y", size_/8)
	label.add_theme_constant_override("shadow_outline_size", size_/4)
	add_child(label)
	return label

func _process(_delta):
	var time=Time.get_ticks_msec()/1000.0
	for letter in _letters:
		if letter.has("dropping"):
			continue
		# decalage entier : le pixel art reste net
		letter.label.position.y=letter.restY+round(sin(time*WAVE_SPEED+letter.phase)*WAVE_AMPLITUDE)

# les lettres tombent du ciel une a une
func playIntro():
	for i in _letters.size():
		var letter=_letters[i]
		letter["dropping"]=true
		letter.label.position.y=letter.restY-DROP_HEIGHT
		letter.label.modulate.a=0.0
		var tween=letter.label.create_tween()
		tween.tween_interval(i*DROP_STAGGER)
		tween.tween_property(letter.label, "modulate:a", 1.0, 0.1)
		tween.parallel().tween_property(letter.label, "position:y", letter.restY, 0.6).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
		tween.tween_callback(func(): letter.erase("dropping"))
