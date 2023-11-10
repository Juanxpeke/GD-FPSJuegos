class_name HelixDescriptor3
extends CellDescriptor

# Gets the unit directions
func get_directions() -> Array[Array]:
	return [
		# We want the piece to be blockable
		# These directions dont allow it
		[Vector2i(0, 1)],
		[Vector2i(-1, 0)],
		[Vector2i(0, -1)],
		[Vector2i(1, 0)],
		
		[Vector2i(0, 2)],
		[Vector2i(-2, 0)],
		[Vector2i(0, -2)],
		[Vector2i(2, 0)],
		
		[Vector2i(-2, 1)],
		[Vector2i(1, 2)],
		[Vector2i(-1, -2)],
		[Vector2i(2, -1)],
		
		[Vector2i(-2, 2)],
		[Vector2i(2, 2)],
		[Vector2i(-2, -2)],
		[Vector2i(2, -2)],
		
		[Vector2i(-2, 3)],
		[Vector2i(3, 2)],
		[Vector2i(-3, -2)],
		[Vector2i(2, -3)]
	]
