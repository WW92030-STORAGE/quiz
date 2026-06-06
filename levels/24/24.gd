extends Node2D

@onready var CORRECT_ANS = get_meta("correct")
@onready var SUCC = get_meta("succ")

@onready var ballfactory = preload("res://levels/24/ball.tscn")

func _ready():
	$ColorRect/Number.text = name
	print(SUCC)
	create_balls()
	
	
	$MarginContainer.hide()	
	
	var bomb = preload("res://elements/bomb.tscn").instantiate()
	bomb.global_position = Globals.BOMB_DEFAULT_POS
	bomb.set_meta("TIME", 10)
	add_child(bomb)
	
	await get_tree().create_timer(2).timeout
	$Label.hide()
	
func _process(delta):
	var hasred = false
	for node in $Node2D/Node2D.get_children():
		if node.get_meta("color") == Color(1, 0, 0):
			hasred = true
			break
	
	if not hasred:
		Globals.status.emit(true)
	
func create_balls():
	var prng = RandomNumberGenerator.new()
	prng.seed = 67 + 69
	
	for y in range(8):
		for x in range(1152 / 128):
			var xpos = x * 128 + (y % 2) * 64
			var ypos = y * 128
			var ball = ballfactory.instantiate()
			ball.global_position = Vector2(xpos, -1 * ypos)
			var sc = prng.randi_range(3, 8) * 0.125
			
			var col_index = prng.randi_range(1, 6)
			var col = Color(col_index % 2, (col_index / 2) % 2, (col_index / 4))
			
			ball.set_meta("scale", sc)
			ball.set_meta("color", col)
			$Node2D/Node2D.add_child(ball)
