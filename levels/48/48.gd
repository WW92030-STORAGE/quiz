extends Node2D

@onready var CORRECT_ANS = get_meta("correct")
@onready var SUCC = get_meta("succ")

func _ready():
	$Descriptions.hide()
	$Label.show()
	$ColorRect/Number.text = name
	print(SUCC)
	await get_tree().create_timer(2).timeout
	$Label.hide()


@onready var DESCS = {
	$Buttons/blue_paper: "BLUE PAPER\nSomething to make Ddakji with",
	$Buttons/mersenne: "MERSENNE\nA protogen who exists somewhere",
	$Buttons/aemythist: "AEMYTHIST\nA problem-solving gemstone",
	$Buttons/bug: "BUG\nWanted by CiPrOS",
	$Buttons/danny: "DANNY\nuhhh danny",
	$Buttons/mobius: "MOBIUS\n:)",
	$Buttons/flatjewel12: "FLATJEWEL12\nChess guru",
	$Buttons/booper: "BOOPER\nNo beans at coinbase :(",
	$Buttons/whiteboard: "WHITEBOARD\nIt's a drawing of you for some reason...?",
	$Buttons/beepy: "BEEPY\nMini-Mersenne?",
	$Buttons/laser: "LASER\nNot to be confused with Emerald or Retro",
	$Buttons/orbit: "ORBIT\nBy Mindcap, verified by Zoink",
	$Buttons/laptop: "LAPTOP\nDoes not use Arch btw",
	$Buttons/abyss: "CUBE\nA bit unusual but not dangerous",
	$Buttons/irridius: "IRRIDIUS\nNot to be confused with Abyss",
	$Buttons/bomb: "BOMB\nWhy are you looking at this you should be solving this problem",
	$Buttons/black_paper: "BLACK PAPER\nprobably not the answer"
}


func _on_wrong_button_down(source: BaseButton) -> void:
	Globals.status.emit(false)


func _on_wrong_mouse_exited(source: Control) -> void:
	$Descriptions.hide()


func _on_wrong_mouse_entered(source: Control) -> void:
	if source in DESCS:
		$Descriptions/Label2.text = DESCS[source]
	$Descriptions.show()
	
