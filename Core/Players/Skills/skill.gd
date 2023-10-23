extends Node
class_name Skill

var texture_path = "res://assets/skill icons/skill issue.png"
var description = "skill description"


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	print(get_script().resource_path.get_file())
	name = get_script().resource_path.get_file().split(".")[0]
	_initialize_attributes()

# override this as init
func _initialize_attributes() -> void:
	pass

func modify_current_cell_descriptor(unit : Unit) -> void:
	pass

func end_turn() -> void:
	pass

func add_to_player(player: Player) -> void:
	player.active_skills.append(self)
	
func _to_string() -> String:
	return get_script().resource_path.get_file().split(".")[0]
