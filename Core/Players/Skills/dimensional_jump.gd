extends Skill
class_name DimensionalJump


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	texture_path = "res://assets/skill icons/dimensionalgap.png"
	description = "Units can move across the lateral sides of the board and will appear on the opossite side on the board"


func modify_current_cell_descriptor(unit : Unit) -> void:
	for cd in unit.current_cell_descriptors:
		cd.wrap_around = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
