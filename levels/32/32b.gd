extends Node2D
var term = 0
func _ready():
	term = randi_range(0, -1 + len(Globals.SECOND_TERMS))
	$Term.text = str(Globals.SECOND_TERMS[term].to_upper())
	Globals.TERMS[1] = term
	
	print(Globals.TERMS, Globals.SECOND_TERMS)
	
	

func _on_continue_button_down() -> void:
	# Change music!
	Globals.GAME_MUSIC.stream = load("res://music/haydn.mp3")
	Globals.GAME_MUSIC.play(3.1)
	Globals.status.emit(true)
