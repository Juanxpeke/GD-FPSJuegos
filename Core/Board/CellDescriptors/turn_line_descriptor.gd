class_name RightLineDescriptor
extends CellDescriptor

var turn_directions = [
	[Vector2i(0, -1)],
	[Vector2i(1, 0)],
	[Vector2i(0, 1)],
	[Vector2i(-1, 0)]
] 

# Gets the unit directions
func get_directions() -> Array[Array]:
	if not GameManager.map: return [turn_directions[0]]
	
	return [turn_directions[(direction_index) % turn_directions.size()]]
