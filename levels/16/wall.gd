extends Area2D

var INIT_POS = global_position
@onready var DISP = get_meta("disp")

func _ready():
	INIT_POS = global_position
	
func _process(delta):
	var time = Time.get_ticks_msec() * 0.001
	var frac = time - floori(time)
	
	if frac < 0.5:
		global_position = INIT_POS + 128 * DISP * frac
	else:
		global_position = INIT_POS + 128 * DISP * (1.0 - frac)
		
	# print(frac, INIT_POS, global_position)
