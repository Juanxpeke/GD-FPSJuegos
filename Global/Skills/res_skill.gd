class_name ResSkill
extends Resource

@export var name: String
@export var description: String
@export var icon: Texture2D
# Attributes
@export var phase_damage_addition: int = 0
@export var phase_reward_addition: int = 0
@export var remove_unit_sale_discount: bool = false
@export var extra_skill_options: int = 0

# Public

# Adds itself to the player
func add_to_player(player: Player) -> void:
	player.skills.append(self)

# Modifies the unit current cell descriptor
func modify_current_cell_descriptor(unit: Unit) -> void:
	pass

