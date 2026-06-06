extends Node2D

@onready var CORRECT_ANS = get_meta("correct")
@onready var SUCC = get_meta("succ")

@onready var VALUE = 2

var KE_THRESHOLD = 16
var PREV_KE = 0

func _ready():
	$ColorRect/Number.text = name
	print(SUCC)
	await get_tree().create_timer(4).timeout
	$Label.hide()
func button_press(node, index):
	# print(node, index)
	var iscorrect = index in CORRECT_ANS
	Globals.button_pressed.emit(node, index, iscorrect)

func _process(delta):
	$Node2D/RigidBody2D/Label.text = str(VALUE)
	if Input.is_action_pressed("MOUSE"):
		var diff = get_viewport().get_mouse_position() - $Node2D/RigidBody2D.position
		$Node2D/RigidBody2D.apply_central_force(4 * diff * $Node2D/RigidBody2D.mass * $Node2D/RigidBody2D.gravity_scale)

func _physics_process(delta):
	var KE = $Node2D/RigidBody2D.linear_velocity.length_squared() * 0.5
	KE += 0.5 * $Node2D/RigidBody2D.angular_velocity * $Node2D/RigidBody2D.angular_velocity
	if KE > KE_THRESHOLD:
		$Node2D/RigidBody2D/Sprite2D.modulate = Color(1, 1, 1)
	else:
		$Node2D/RigidBody2D/Sprite2D.modulate = Color(0, 1, 0)

func _on_rigid_body_2d_body_entered(body: Node) -> void:
	print($Node2D/RigidBody2D.linear_velocity)
	var KE = $Node2D/RigidBody2D.linear_velocity.length_squared() * 0.5
	KE += 0.5 * $Node2D/RigidBody2D.angular_velocity * $Node2D/RigidBody2D.angular_velocity
	print(KE)
	if KE > 1000 and not Input.is_action_pressed("MOUSE"):
		print("COLLIDED")
		VALUE = (VALUE + 1) % 6
	


func _on_button_button_down() -> void:
	var KE = $Node2D/RigidBody2D.linear_velocity.length_squared() * 0.5
	KE += 0.5 * $Node2D/RigidBody2D.angular_velocity * $Node2D/RigidBody2D.angular_velocity
	print(KE, VALUE)
	if KE <= KE_THRESHOLD and VALUE == 0:
		Globals.status.emit(true)
