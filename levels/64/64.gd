extends Node2D

@onready var CORRECT_ANS = get_meta("correct")
@onready var SUCC = get_meta("succ")

@onready var BUTTONS = [$Buttons/Button1, $Buttons/Button2, $Buttons/Button3, $Buttons/Button4, $Buttons/Button5, $Buttons/Button6, $Buttons/Button7, $Buttons/Button8, $Buttons/Button9]
@onready var KEYPAD = [$Keypad/buttons/Button0, $Keypad/buttons/Button1, $Keypad/buttons/Button2, $Keypad/buttons/Button3, $Keypad/buttons/Button4, $Keypad/buttons/Button5, $Keypad/buttons/Button6, $Keypad/buttons/Button7, $Keypad/buttons/Button8, $Keypad/buttons/Button9]

@onready var PULSE = [$Pulse/Sprite2D, $Pulse/Sprite2D2, $Pulse/Sprite2D3, $Pulse/Sprite2D4]

var ITERATION = 0

var NONCE = ""

var WHITE = 0
var bg_on = false
var colorIndex = 0

var DIFF = 4

# If you have accrued EXP this problem becomes harder for the uninitiated

func _ready():
	if Globals.EXP <= 0:
		pass
		# DIFF = 3
	
	
	$Pulse.hide()
	Globals.GAME_MUSIC.stream = load("res://music/ending.mp3")
	Globals.GAME_MUSIC.play()
	$Buttons.show()
	$Keypad.hide()
	$ColorRect/Number.text = name
	print(SUCC)
	
	for i in range(10):
		KEYPAD[i].text = str(i)
		
	await get_tree().create_timer(16.5).timeout
	RAINBOWSANDUNICORNS()

func BLEACHIFY(thing):
	for node in thing.get_children():
		BLEACHIFY_NODE(node)

func BLEACHIFY_NODE(node):
		if node is Label:
			node.add_theme_color_override("font_color", Color(1, 1, 1))
		if node is ColorRect:
			node.color = Color(1, 1, 1)
		if node is Button:
			var new_stylebox_normal = node.get_theme_stylebox("normal").duplicate()
			new_stylebox_normal.border_color = Color(1, 1, 1)
			node.add_theme_stylebox_override("normal", new_stylebox_normal)
			
	
func RAINBOWSANDUNICORNS():
	$Pulse.show()
	for pulse in PULSE:
		pulse.modulate = Color(0, 0, 0)
	
	bg_on = true
	WHITE = 1
	
	BLEACHIFY(get_parent())
	BLEACHIFY(get_parent().get_parent())
	BLEACHIFY(self)
	BLEACHIFY($BOMB)
	BLEACHIFY($Buttons)
	BLEACHIFY($Keypad/buttons)
	BLEACHIFY_NODE($Keypad/Button)
	BLEACHIFY_NODE($Keypad/Label)
	BLEACHIFY_NODE($Keypad/Label2)
	
func update_bg_rainbow():
	colorIndex = (colorIndex + 6) % (6 * 256)
	var red = 0
	var green = 0
	var blue = 0
	var index = int(colorIndex / 256)
	var val = (colorIndex / 256.0) - index
	
	if (index == 0):
		red = 1
		blue = 0
		green = val
	elif (index == 1):
		red = 1 - val
		green = 1
		blue = 0
	elif (index == 2):
		red = 0
		green = 1
		blue = val
	elif (index == 3):
		red = 0
		green = 1 - val
		blue = 1
	elif (index == 4):
		red = val
		green = 0
		blue = 1
	elif (index == 5):
		red = 1
		green = 0
		blue = 1 - val
	else:
		red = 1
		green = 1
		blue = 1
	
	if bg_on:
		$ColorRect2.color = lerp(Color(red, green, blue), Color(1, 1, 1), WHITE)
	else:
		pass
func _process(delta):
	update_bg_rainbow()
	$Label.text = "ENTER THE CODES"
	if WHITE > 0:
		WHITE -= (1.0 / 256.0)
	if ITERATION == 0:
		$Label.add_theme_color_override("font_color", Color(1, 0, 0))
		for i in range(9):
			BUTTONS[i].text = Globals.FIRST_TERMS[i]
	elif ITERATION == 1:
		$Label.add_theme_color_override("font_color", Color(0, 1, 0))
		for i in range(9):
			BUTTONS[i].text = Globals.SECOND_TERMS[i]
	elif ITERATION == 2:
		$Label.add_theme_color_override("font_color", Color(0, 0, 1))
		for i in range(9):
			BUTTONS[i].text = Globals.THIRD_TERMS[i]
	else:
		$Label.add_theme_color_override("font_color", Color(1, 1, 1))
		$Buttons.hide()
		$Keypad.show()
		
		$Keypad/Label2.text = str(NONCE)
		if Globals.EXP <= 0:
			$Label.text = "ENTER THE CODES\nDIFF-" + str(DIFF)
		
	# decoration
	var pulse_scale = Globals.normalizedVolume()
	for pulse in PULSE:
		pulse.global_scale.x = pulse_scale
	$Keypad/Sprite2D.scale = Vector2(12, 1) + Vector2.ONE * pulse_scale * 0.5


func _on_button_button_down(source: BaseButton) -> void:
	var BUTTON_INDEX = 0
	for i in range(9):
		if BUTTONS[i] == source:
			BUTTON_INDEX = i
	if ITERATION < 3:
		if Globals.TERMS[ITERATION] != BUTTON_INDEX:
			Globals.status.emit(false)
		else:
			ITERATION += 1

func _on_clear_button_down() -> void:
	NONCE = ""


func _on_backspace_button_down() -> void:
	if len(NONCE) > 0:
		NONCE = NONCE.substr(0, len(NONCE) - 1)


func _on_submit_button_down() -> void:
	var SUBMIT = Globals.FIRST_TERMS[Globals.TERMS[0]] + Globals.SECOND_TERMS[Globals.TERMS[1]] + Globals.THIRD_TERMS[Globals.TERMS[2]] + NONCE
	print(SUBMIT)
	var sha256 = Globals.compute_sha256(SUBMIT)
	print(sha256)
	for i in range(DIFF):
		if sha256[i] != '0':
			Globals.status.emit(false)
			return
	
	Globals.status.emit(true)

# keypad
func _on_button_0_button_down(source: BaseButton) -> void:
	if len(NONCE) >= 13:
		return
	for i in range(10):
		if KEYPAD[i] == source:
			NONCE = NONCE + str(i)
