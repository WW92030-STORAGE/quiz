extends RigidBody2D

func _ready():
	$CollisionShape2D/Sprite2D.modulate = get_meta("color")
	var sc = get_meta("scale")
	$CollisionShape2D.apply_scale(Vector2(sc, sc))
	$Area2D/CollisionShape2D.apply_scale(Vector2(sc, sc))

func _process(delta):
	pass
	


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("MOUSE"):
		if get_meta("color") != Color(1, 0, 0):
			Globals.status.emit(false)
		else:
			queue_free()
