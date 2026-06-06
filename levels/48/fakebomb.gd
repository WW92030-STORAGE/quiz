extends Node2D

@onready var BEGIN = Time.get_ticks_msec()

func _ready():
	pass
	
func _process(delta):
	var TIME = get_meta("TIME")
	var seconds = int((Time.get_ticks_msec() - BEGIN) / 1000)
	if seconds >= TIME:
		$ColorRect/ColorRect2/Label.add_theme_font_size_override("font_size", 120)
		$ColorRect/ColorRect2/Label.text = "DUD"
		$AudioStreamPlayer2D.play()
		await get_tree().create_timer(1).timeout
		Globals.status.emit(true)
	
	var rem = TIME - seconds
	$ColorRect/ColorRect2/Label.text = str(rem)
	if rem < 100:
		$ColorRect/ColorRect2/Label.add_theme_font_size_override("font_size", 160)
