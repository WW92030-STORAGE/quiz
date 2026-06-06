extends Node2D
var term = 0
func _ready():
	term = randi_range(0, -1 + len(Globals.THIRD_TERMS))
	$Term.text = str(Globals.THIRD_TERMS[term].to_upper())
	Globals.TERMS[2] = term
	
	print(Globals.TERMS, Globals.THIRD_TERMS)
	
	

func _on_continue_button_down() -> void:
	# Change music!
	Globals.GAME_MUSIC.stream = load("res://music/sonata.mp3")
	Globals.GAME_MUSIC.play(4.2)
	Globals.status.emit(true)
