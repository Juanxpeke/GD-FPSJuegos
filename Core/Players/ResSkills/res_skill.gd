class_name ResSkill
extends Resource

@export var name: String
@export var description: String
@export var icon: Texture2D

# Modifies the player

# Modifies the unit current cell descriptor
func modify_current_cell_descriptor(unit: Unit) -> void:
	pass
