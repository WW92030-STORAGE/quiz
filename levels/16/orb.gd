extends Area2D

func _ready():
	pass
	
func _process(delta):
	var time = Time.get_ticks_msec() * 0.001
	var frac = time - floori(time)
	
	var sc = 1
	if frac < 0.5:
		sc = 2 * frac
	else:
		sc = 2 * (1.0 - frac)
		
	global_scale = Vector2(sc, sc)
		
	# print(frac, INIT_POS, global_position)
