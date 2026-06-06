extends Node2D


@onready var CORRECT_ANS = get_meta("correct")
@onready var SUCC = get_meta("succ")

func _ready():
	$ColorRect/Number.text = name
	print(SUCC)
	
	init()
	
func _process(delta):
	pass
	
func init():
	$Label2.hide()
	$MarginContainer.show()

func _on_texture_button_button_down() -> void:
	$MarginContainer.hide()
	$Label2.show()
	await get_tree().create_timer(4).timeout
	$Label2.hide()
	
func life_lost():
	Globals.status.emit(false)
	init()


func _on_texture_button_mouse_entered() -> void:
	life_lost()


func _on_area_2d_mouse_entered() -> void:
	print("!!!!")
	life_lost()


func _on_texture_button_2_button_down() -> void:
	print("!!!")
	Globals.status.emit(true)


func _on_end_mouse_entered() -> void:
	print("!!!")
	Globals.status.emit(true)
