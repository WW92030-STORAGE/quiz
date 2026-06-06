extends Node2D

func _ready():
	Globals.SKIPS += 1
	await get_tree().create_timer(1).timeout
	Globals.status.emit(true)
