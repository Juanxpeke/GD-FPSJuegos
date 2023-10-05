extends Skill
class_name DimensionalJump


# Called when the node enters the scene tree for the first time.
func _init() -> void:
	texture_path = "res://assets/skill icons/dimensionalgap.png"
	description = """Units can move across the lateral sides of
		the board and will appear on the opossite side on the board"""


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
