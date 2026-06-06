extends RigidBody2D

var base_size = 64
var inner_scale = 0.9
@onready var size = get_meta("size")

func _ready():
	var sc = size / base_size
	$Sprite2D.global_scale = sc
	$Sprite2D2.global_scale = sc * inner_scale
	$CollisionShape2D.global_scale = sc
	mass = sc.x * sc.y

func _process(delta):
	var sc = size * (inner_scale * Globals.normalizedVolume() / base_size)
	$pulsing.global_scale = sc
