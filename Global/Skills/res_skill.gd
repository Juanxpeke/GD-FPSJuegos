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
@export var permanent_leveled_up_units: Array[String] = [] 

# Public

# Adds itself to the player
func add_to_player(player: Player) -> void:
	for unit in player.match_live_units:
		if unit.get_unit_class() in permanent_leveled_up_units:
			unit.change_level.rpc(unit.level + 1)
	
	player.skills.append(self)

# Modifies the unit current cell descriptor
func modify_current_cell_descriptor(unit: Unit) -> void:
	pass

