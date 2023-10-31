class_name ResSkill
extends Resource

@export var name: String
@export var description: String
@export var icon: Texture2D

# Public

# Adds itself to the player
func add_to_player(player: Player) -> void:
	player.skills.append(self)

# Modifies the unit current cell descriptor
func modify_current_cell_descriptor(unit: Unit) -> void:
	pass
