extends Node2D


func _on_begin_button_down() -> void:
	Globals.start_game()


func _on_help_button_down() -> void:
	get_tree().change_scene_to_file("res://help.tscn")


func _on_credits_button_down() -> void:
	get_tree().change_scene_to_file("res://credits.tscn")


func _on_contact_button_down() -> void:
	OS.shell_open("https://normalexisting.neocities.org")
