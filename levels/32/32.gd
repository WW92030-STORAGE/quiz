extends Node2D

@onready var CORRECT_ANS = get_meta("correct")
@onready var SUCC = get_meta("succ")
@onready var QUEUE = get_meta("queue")

@onready var INDEX = 0
var START_CHECK = -1
var SECONDS = 8
# 0 = rect, 1 = circle

var base_sizes = [64, 256]

func _ready():
	$ColorRect/Number.text = "20"
	print("NAME", name)
	print(SUCC)
	await get_tree().create_timer(4).timeout
	$Label.hide()
	
func fail():
	for body in $Node2D.get_children():
		if body is RigidBody2D:
			body.queue_free()
	
	Globals.status.emit(false)
	INDEX = -32
	
func _process(delta):
	if INDEX < 0:
		INDEX += 1
		$Indicators/CircleLabel.hide()
		$Indicators/BoxLabel.hide()
		START_CHECK = -1
		return
	var mouse_pos = get_viewport().get_mouse_position()
	
	if INDEX >= len(QUEUE):
		$Indicators/CircleLabel.hide()
		$Indicators/BoxLabel.hide()
		return
	
	var shape = QUEUE[INDEX].x
	if shape == 0:
		$Indicators/CircleLabel.hide()
		$Indicators/BoxLabel.show()
	elif shape == 1:
		$Indicators/BoxLabel.hide()
		$Indicators/CircleLabel.show()
	$Indicators.global_position = mouse_pos
	
	var width = QUEUE[INDEX].y
	var height = QUEUE[INDEX].z
	$Indicators/BoxLabel.global_scale = Vector2(width / base_sizes[shape], height / base_sizes[shape])
	$Indicators/CircleLabel.global_scale = Vector2(width / base_sizes[shape], height / base_sizes[shape])

func _physics_process(delta):
	if INDEX < 0:
		return
	var allgood = true
	var failed = false
	for body in $Node2D.get_children():
		if not body is RigidBody2D:
			continue
		if not body.sleeping:
			allgood = false
		
		if body.global_position.y > 1024:
			fail()
	if allgood and INDEX >= len(QUEUE):
		print("PASSED BY SLEEPING")
		Globals.status.emit(true)
	
	if INDEX >= len(QUEUE):
		if START_CHECK < 0:
			START_CHECK = Time.get_ticks_msec()
		elif Time.get_ticks_msec() >= START_CHECK + 1000 * SECONDS:
			Globals.status.emit(true)
			
func _input(event):
	if INDEX < 0:
		return
	if event.is_action_pressed("MOUSE"):
		# Query the physics state to see if we are intersecting
		# based on this: https://www.reddit.com/r/godot/comments/x98pyn/detecting_if_the_mouse_is_currently_inside_an/
		var query = PhysicsPointQueryParameters2D.new()
		var mouse_pos = get_viewport().get_mouse_position()
		query.position = mouse_pos
		query.collide_with_bodies = true
	
		var results = get_world_2d().direct_space_state.intersect_point(query)
		if len(results) > 0:
			pass
		elif INDEX < len(QUEUE):
			var shape = QUEUE[INDEX].x
			var width = QUEUE[INDEX].y
			var height = QUEUE[INDEX].z
			
			if shape == 0:
				var body = load("res://levels/32/box.tscn").instantiate()
				body.set_meta("size", Vector2(width, height))
				body.global_position = mouse_pos
				$Node2D.add_child(body)
			elif shape == 1:
				var body = load("res://levels/32/ball.tscn").instantiate()
				body.set_meta("size", Vector2(width, height))
				body.global_position = mouse_pos
				$Node2D.add_child(body)
			
			INDEX += 1
