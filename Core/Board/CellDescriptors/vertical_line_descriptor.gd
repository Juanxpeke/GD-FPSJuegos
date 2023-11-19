class_name VerticalLineDescriptor
extends CellDescriptor
	
# Gets the unit directions
func get_directions() -> Array[Array]:
	return [
		[Vector2i(0, 1)],
		[Vector2i(0, -1)]
	]
	

