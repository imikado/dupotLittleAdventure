extends CanvasLayer

# Ecran de fin : fenetre parchemin par-dessus le village, textes traduits

signal backToMenu

func _ready():
	visible=false
	refreshUi()

func refreshUi():
	$window/list/title.text=GlobalGame.getTraductionById(GlobalGame.TRAD_END_TITLE)
	$window/list/message.text=GlobalGame.getTraductionById(GlobalGame.TRAD_END_MESSAGE)
	$window/list/button.text=GlobalGame.getTraductionById(GlobalGame.TRAD_LABEL_RETOURAUMENU)

func showEnd():
	refreshUi()
	visible=true
	Sfx.play(Sfx.VICTORY)
	# le fond s'assombrit, puis la fenetre se deplie
	var backdrop=$backdrop
	var window=$window
	backdrop.modulate.a=0.0
	window.pivot_offset=window.size/2
	window.scale=Vector2(1, 0.1)
	window.modulate.a=0.0
	var tween=create_tween()
	tween.tween_property(backdrop, "modulate:a", 1.0, 0.4)
	tween.tween_property(window, "modulate:a", 1.0, 0.05)
	tween.tween_property(window, "scale:y", 1.0, 0.15).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	await tween.finished
	$window/list/button.grab_focus()

func _on_button_pressed():
	emit_signal("backToMenu")
	SceneTransition.change_scene("res://screens/game/menu.tscn")
