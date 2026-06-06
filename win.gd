extends Node2D


func _on_back_button_down() -> void:
	get_tree().change_scene_to_file("res://menu.tscn")

func _ready():
	$stats.text = str(Globals.CLICKS) + " CLICKS\n" + str(Globals.STARTING_LIVES - Globals.LIVES) + " MISTAKES\n" + str(Globals.SKIPS_USED) + " SKIPS" 
