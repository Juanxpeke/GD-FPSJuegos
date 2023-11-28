class_name MatchLineDescriptor
extends CellDescriptor

# Gets the unit directions
func get_directions() -> Array[Array]:
	if not GameManager.map:
		return [
			[Vector2i(1, 0)],
			[Vector2i(-1, 0)]
		]
	
	if GameManager.map.matchi % 2 != 0:
		return [
			[Vector2i(0, 1)],
			[Vector2i(0, -1)]
		]
	return [
		[Vector2i(1, 0)],
		[Vector2i(-1, 0)]
	]
