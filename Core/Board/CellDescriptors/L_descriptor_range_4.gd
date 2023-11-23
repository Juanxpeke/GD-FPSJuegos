class_name LDescriptorRange4
extends CellDescriptor

# Gets the unit directions
func get_directions() -> Array[Array]:
	return [
		[Vector2i(0, 1), Vector2i(0, 1), Vector2i(0, 1), Vector2i(0, 1), Vector2i(1, 0)],
		[Vector2i(0, 1), Vector2i(0, 1), Vector2i(0, 1), Vector2i(0, 1), Vector2i(-1, 0)],
		[Vector2i(-1, 0), Vector2i(-1, 0), Vector2i(-1, 0), Vector2i(-1, 0), Vector2i(0, 1)],
		[Vector2i(-1, 0), Vector2i(-1, 0), Vector2i(-1, 0), Vector2i(-1, 0), Vector2i(0, -1)],
		[Vector2i(0, -1), Vector2i(0, -1), Vector2i(0, -1), Vector2i(0, -1), Vector2i(1, 0)],
		[Vector2i(0, -1), Vector2i(0, -1), Vector2i(0, -1), Vector2i(0, -1), Vector2i(-1, 0)],
		[Vector2i(1, 0), Vector2i(1, 0), Vector2i(1, 0), Vector2i(1, 0), Vector2i(0, 1)],
		[Vector2i(1, 0), Vector2i(1, 0), Vector2i(1, 0), Vector2i(1, 0), Vector2i(0, -1)],
	]
