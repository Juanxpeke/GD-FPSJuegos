class_name MaceCustomDescriptorHorizontal
extends CellDescriptor 
	
# Gets the unit directions
func get_directions() -> Array[Array]:
	return [
		[Vector2i(1, 1), Vector2i(1, 1), Vector2i(1, 1), Vector2i(1, 0)],
		[Vector2i(-1, 1), Vector2i(-1, 1), Vector2i(-1, 1), Vector2i(-1, 0)],
		[Vector2i(-1, -1), Vector2i(-1, -1), Vector2i(-1, -1), Vector2i(-1, 0)],
		[Vector2i(1, -1), Vector2i(1, -1), Vector2i(1, -1), Vector2i(1, 0)]
	]
