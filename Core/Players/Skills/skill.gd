extends Node
class_name Skill

var texture_path = "res://assets/skill icons/skill issue.png"
var description = "skill description"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func modify_current_cell_descriptor(unit : Unit) -> void:
	pass

func end_turn() -> void:
	pass

func add_to_player(player: Player) -> void:
	player.active_skillls.append(self)
	
