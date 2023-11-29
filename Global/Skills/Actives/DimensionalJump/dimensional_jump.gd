class_name DimensionalJump
extends ResActiveSkill

# Modifies the unit current cell descriptor
func modify_current_cell_descriptor(unit : Unit) -> void:
	for cd in unit.current_cell_descriptors:
		cd.wrap_around = true