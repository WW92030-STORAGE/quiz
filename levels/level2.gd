extends Node2D

@onready var CORRECT_ANS = get_meta("correct")
@onready var PLUS_EXP = get_meta("exp")
@onready var SUCC = get_meta("succ")

func _ready():
	$ColorRect/Number.text = name
	print(SUCC)
func button_press(node, index):
	print(node, index)
	var iscorrect = index in CORRECT_ANS
	if iscorrect:
		Globals.status.emit(true)
	elif index in PLUS_EXP:
		Globals.EXP += 1
		Globals.status.emit(true)
	else:
		Globals.status.emit(false)

func _on_button_1_button_down() -> void:
	button_press($Buttons/Button1, 0)
	pass # Replace with function body.


func _on_button_2_button_down() -> void:
	button_press($Buttons/Button2, 1)
	pass # Replace with function body.


func _on_button_3_button_down() -> void:
	button_press($Buttons/Button3, 2)
	pass # Replace with function body.


func _on_button_4_button_down() -> void:
	button_press($Buttons/Button4, 3)
	pass # Replace with function body.
