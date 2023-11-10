class_name LDescriptor
extends CellDescriptor

# Gets the unit directions
func get_directions() -> Array[Array]:
	return [
		[Vector2i(1 , 1 )],
		[Vector2i(1 , 1 )],
		[Vector2i(1 , -1 )],
		[Vector2i(1 , -1 )],	
		[Vector2i(-1, 1 )],
		[Vector2i(-1, 1)],
		[Vector2i(-1 , -1 )],
		[Vector2i(-1 , -1 )]
	]
	
# Gets the unit base movements
func get_base_movement() -> Array[Vector2i]:
	return [
		Vector2i(0, 1),
		Vector2i(1, 0),
		Vector2i(0, -1),
		Vector2i(1, 0),	
		Vector2i(0, 1),
		Vector2i(-1, 0),
		Vector2i(0, -1),
		Vector2i(-1, 0)
	]
	
# DEPRECATED

# Returns the set of cells only by a certain index
func _get_cells_by_index(origin_cell: Vector2i, index: int) -> Array:
	return [
		origin_cell + Vector2i(index + 1, index + 2),
		origin_cell + Vector2i(index + 2, index + 1),
		origin_cell + Vector2i(index + 1, -index - 2),
		origin_cell + Vector2i(index + 2, -index - 1),
		origin_cell + Vector2i(-index - 1, index + 2),
		origin_cell + Vector2i(-index - 2, index + 1),
		origin_cell + Vector2i(-index - 1, -index - 2),
		origin_cell + Vector2i(-index - 2, -index - 1)
	]

# END DEPRECATED
