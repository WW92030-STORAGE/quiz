extends Node2D

func _ready():
	await get_tree().create_timer(0.2).timeout
	$ColorRect2.color = Color(1, 1, 1)
	await get_tree().create_timer(0.2).timeout
	$ColorRect2.hide()

func _on_title_button_down() -> void:
	get_tree().change_scene_to_file("res://menu.tscn")


func _on_restart_button_down() -> void:
	Globals.start_game()
