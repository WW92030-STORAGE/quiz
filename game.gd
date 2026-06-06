extends Node2D

func wrongans_indicator():
	$wrong.play(1.03)
	$WRONGANS.show()
	await get_tree().create_timer(0.25).timeout
	$WRONGANS.hide()
	
func advance():
	$advance.play()
	var succ = null
	for child in $LevelContainer.get_children():
		succ = child.get_meta("succ")
	for child in $LevelContainer.get_children():
		child.queue_free()
	if succ == null:
		print("NO SUCC")
		return
	var x = succ.instantiate()
	print("SUCC", x)
	$LevelContainer.add_child(x)

# this method is technically redundant but it's here because i'm too lazy to do anything about it
# it's the special case of status(node, iscorrect) for a button-based question
func button_press(node, index, iscorrect):
	print(node, index, iscorrect)
	
	if not iscorrect:
		Globals.LIVES -= 1
		await wrongans_indicator()
	else:
		advance()
		
func status(iscorrect):
	if not iscorrect:
		Globals.LIVES -= 1
		await wrongans_indicator()
	else:
		advance()
		
func instakill():
	Globals.LIVES = 0

func _ready():
	Globals.GAME_MUSIC = $music
	var level = preload("res://levels/01.tscn").instantiate()
	$LevelContainer.add_child(level)
	print("INIT")
	
	$WRONGANS.hide()   
	
	Globals.connect("button_pressed", button_press)
	Globals.connect("status", status)
	Globals.connect("instakill", instakill)
	
	print(Globals.compute_sha256("sus"))
	
	await get_tree().create_timer(67).timeout
	$misc.stream = load("res://sound/special.mp3")
	$misc.play()
	await get_tree().create_timer(42).timeout
	# $misc.stream = load("res://sound/error.mp3")
	# $misc.play()
	

func _process(delta):
	if Input.is_action_just_pressed("TAB"):
		Globals.LIVES = 0
	
	$LIVES.text = "LIVES-" + str(Globals.LIVES)
	$SKIPS.text = "SKIPS-" + str(Globals.SKIPS)
	$CLICKS.text = str(Globals.CLICKS) + " CLICKS"
	if Globals.CLICKS > 99999:
		$CLICKS.text = ">99999 CLICKS"
		
	if Globals.LIVES <= 0:
		get_tree().change_scene_to_file("res://dead.tscn")
		
	var skips_disabled = false
	for node in $LevelContainer.get_children():
		skips_disabled = skips_disabled or node.get_meta("skips_disabled")
	$SKIPS.disabled = skips_disabled
	if skips_disabled:
		$SKIPS.text = "DISABLED"
	
func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			Globals.CLICKS += 1


func _on_skips_button_down() -> void:
	var skips_disabled = false
	for node in $LevelContainer.get_children():
		skips_disabled = skips_disabled or node.get_meta("skips_disabled")
	if skips_disabled:
		return
	if Globals.SKIPS > 0:
		Globals.SKIPS_USED += 1
		Globals.SKIPS -= 1
		advance()
