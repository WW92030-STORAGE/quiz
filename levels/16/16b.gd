extends Node2D
var term = 0
func _ready():
	term = randi_range(0, -1 + len(Globals.FIRST_TERMS))
	$Term.text = str(Globals.FIRST_TERMS[term].to_upper())
	Globals.TERMS[0] = term
	
	print(Globals.TERMS, Globals.FIRST_TERMS)
	
	

func _on_continue_button_down() -> void:
	# Change music!
	Globals.GAME_MUSIC.stream = load("res://music/concerto3.mp3")
	Globals.GAME_MUSIC.play()
	Globals.status.emit(true)
