extends ResActive
class_name Ghost2



func modify_current_cell_descriptor(unit : Unit) -> void:
	for descriptor in unit.current_cell_descriptors:
		descriptor.is_blockable = false
