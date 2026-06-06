extends Node2D

@onready var CORRECT_ANS = get_meta("correct")
@onready var SUCC = get_meta("succ")

@onready var BUTS = [
	[$Node2D/b0, $Node2D/b1, $Node2D/b2, $Node2D/b3], 
	[$Node2D/b4, $Node2D/b5, $Node2D/b6, $Node2D/b7], 
	[$Node2D/b8, $Node2D/b9, $Node2D/b10, $Node2D/b11],
	[$Node2D/b12, $Node2D/b13, $Node2D/b14, $Node2D/b15]
]

@onready var PANELS = [
	[$Node2D/Node2D2/Sprite2D0, $Node2D/Node2D2/Sprite2D1, $Node2D/Node2D2/Sprite2D2, $Node2D/Node2D2/Sprite2D3], 
	[$Node2D/Node2D2/Sprite2D4, $Node2D/Node2D2/Sprite2D5, $Node2D/Node2D2/Sprite2D6, $Node2D/Node2D2/Sprite2D7], 
	[$Node2D/Node2D2/Sprite2D8, $Node2D/Node2D2/Sprite2D9, $Node2D/Node2D2/Sprite2D10, $Node2D/Node2D2/Sprite2D11], 
	[$Node2D/Node2D2/Sprite2D12, $Node2D/Node2D2/Sprite2D13, $Node2D/Node2D2/Sprite2D14, $Node2D/Node2D2/Sprite2D15] 
]

@onready var STATUS = [
	[false, false, false, false], 
	[false, false, false, false],
	[false, false, false, false],
	[false, false, false, false]
]

@onready var PANEL_ON = preload("res://assets/colors/green.png")
@onready var PANEL_OFF = preload("res://assets/colors/255.png")

func toggle(x, y):
	var dx = [0, 0, 1, 0, -1]
	var dy = [0, 1, 0, -1, 0]
	
	for i in range(len(dx)):
		var xp = x + dx[i]
		var yp = y + dy[i]
		if xp < 0 or yp < 0 or xp >= len(STATUS) or yp >= len(STATUS[0]):
			continue
		
		STATUS[xp][yp] = not STATUS[xp][yp]

func _ready():
	$ColorRect/Number.text = name
	print(SUCC)
	
	var prng = Globals.compute_sha256("protogens")
	
	for i in range(4):
		# old ver: random
		var x = randi_range(0, len(STATUS) - 1)
		var y = randi_range(0, len(STATUS[0]) - 1)
		
		# new ver: random seeded
		var c = prng[i].hex_to_int()
		x = int(c / 4)
		y = c % 4
	
		
		toggle(x, y)
	
	await get_tree().create_timer(4).timeout
	$Label.hide()

func _process(delta):
	var any_on = false
	for i in range(len(BUTS)):
		for j in range(len(BUTS[i])):
			if STATUS[i][j]:
				PANELS[i][j].texture = (PANEL_OFF)
				any_on = true
			else:
				PANELS[i][j].texture = (PANEL_ON)
	if not any_on:
		Globals.status.emit(true)
				
	

func _on_b_button_down(source: BaseButton) -> void:
	var name = str(source).substr(1, 2)
	if name[1] == ':':
		name = name[0]
	name = int(name)
	print("NAME", name)
	
	var row = int(name / 4)
	var col = name % 4
	
	toggle(row, col)
	print(STATUS)
