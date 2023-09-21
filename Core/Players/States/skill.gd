extends Node
class_name Skill

var player : Player
var cooldown_turns : int = 0
var uses_remaining : int = 9999


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func modify_current_cell_descriptor(unit : Unit) -> void:
	pass

func activate() -> bool:
	if cooldown_turns <= 0 and uses_remaining > 0:
		return true
	return false

