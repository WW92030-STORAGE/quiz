extends Node

var HIDDEN_WORDS = []
var STARTING_LIVES = 5
var LIVES = 5
var SKIPS = 0
var CLICKS = 0
var SKIPS_USED = 0

var EXP = 0

signal button_pressed(node, index, iscorrect)
signal status(iscorrect)
signal instakill()

var VOLUME = 10
var RUNNING_AVG = 0
var RUNNING_STD = 1
var VOLUME_ARRAY = []
var VOLUME_SAMPLES = 64

func compute_volume():
	VOLUME = (AudioServer.get_bus_peak_volume_left_db(1,0) + AudioServer.get_bus_peak_volume_right_db(1,0)) / 2
	VOLUME_ARRAY.append(VOLUME)
	while len(VOLUME_ARRAY) > VOLUME_SAMPLES:
		VOLUME_ARRAY.pop_front()
	
	RUNNING_AVG = 0
	for obj in VOLUME_ARRAY:
		RUNNING_AVG += obj
	if len(VOLUME_ARRAY) > 0:
		RUNNING_AVG /= len(VOLUME_ARRAY)
		
	var variance = 0
	for obj in VOLUME_ARRAY:
		variance += (obj - RUNNING_AVG) * (obj - RUNNING_AVG)
	if len(VOLUME_ARRAY) > 0:
		variance /= len(VOLUME_ARRAY)
	if variance > 0:
		RUNNING_STD = sqrt(variance)
		
func sigmoidpos(x, slope = 1):
	return 1.0 / (1 + exp(-1 * slope * x))
	
func normalizedVolume():
	var normalized = sigmoidpos(VOLUME - RUNNING_AVG, 0.5 / RUNNING_STD)
	if (normalized < 0):
		normalized = 0
	elif (normalized > 1):
		normalized = 1
	return normalized

func _process(delta):
	compute_volume()
	
# At the end of each quadrant you will be given a term. The final question has 

var FIRST_TERMS = ["standard", "elements", "construct", "vorspiel", "protogen", "optimize", "redstone", "spectrum", "mutation"]
var SECOND_TERMS =["corrupt", "reveals", "insight", "warping", "mutated", "crimson", "susanoo", "arduous", "technic"]
var THIRD_TERMS = ["mutate", "ascend", "hallow", "exeunt", "anubis", "return", "player", "fallen", "sunset"]

var TERMS = [1, 2, 4]

var BOMB_DEFAULT_POS = Vector2(1008, 16)

var GAME_MUSIC = null

func init_stats():
	LIVES = STARTING_LIVES
	SKIPS = 0
	CLICKS = 0
	SKIPS_USED = 0
	
	TERMS = [1, 2, 4]
	
	FIRST_TERMS.shuffle()
	SECOND_TERMS.shuffle()
	THIRD_TERMS.shuffle()

func compute_sha256(text):
	var ctx = HashingContext.new()
	ctx.start(HashingContext.HASH_SHA256)
	
	var thing = text.to_utf8_buffer()
	
	ctx.update(thing)
	var res = ctx.finish()
	return res.hex_encode()

func start_game():
	init_stats()
	get_tree().change_scene_to_file("res://game.tscn")
