extends Active
class_name Ghost


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	uses_remaining = 3

func modify_current_cell_descriptor(unit : Unit) -> void:
	for descriptor in unit.current_cell_descriptors:
		descriptor.is_blockable = false
