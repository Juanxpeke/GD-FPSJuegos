extends Active
class_name Ghost


func _initialize_attributes() -> void:
	texture_path = "res://assets/skill icons/Ghost.webp"
	description = "When activated units are allowed to overstep units and other obstacles this turn"
	
	INITIAL_USES = 3
	COOLDOWN = 3
	

func modify_current_cell_descriptor(unit : Unit) -> void:
	for descriptor in unit.current_cell_descriptors:
		descriptor.is_blockable = false
