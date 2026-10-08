extends Control

# Barre de vie de combat : la jauge glisse vers la nouvelle valeur,
# une trainee claire montre les points perdus, la couleur change quand la vie baisse

const COLOR_OK=Color(0.137255, 0.87451, 0.388235)
const COLOR_MEDIUM=Color(1, 0.72, 0.25)
const COLOR_LOW=Color(0.93, 0.27, 0.3)

var maxValue=100
var fillStyle:StyleBoxFlat

func _ready():
	# style propre a chaque instance (sinon les deux barres partagent leur couleur)
	fillStyle=$bar.get_theme_stylebox("fill").duplicate()
	$bar.add_theme_stylebox_override("fill", fillStyle)

func init(title_, currentValue_, maxValue_):
	maxValue=maxValue_
	$titleTab/title.text=title_
	for bar in [$trail, $bar]:
		bar.max_value=maxValue_
		bar.value=currentValue_
	_refresh(currentValue_)

func updateValue(value_):
	var tween=create_tween()
	tween.tween_property($bar, "value", value_, 0.25).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	# la trainee rattrape la jauge avec un temps de retard
	tween.tween_property($trail, "value", value_, 0.4).set_delay(0.15)
	if value_ > $trail.value:
		$trail.value=value_
	_refresh(value_)

func _refresh(value_):
	$value.text=str(value_)+"/"+str(maxValue)
	var ratio=float(value_)/max(1, maxValue)
	var color=COLOR_OK
	if ratio <= 0.25:
		color=COLOR_LOW
	elif ratio <= 0.5:
		color=COLOR_MEDIUM
	fillStyle.bg_color=color.darkened(0.35)
	fillStyle.border_color=color
