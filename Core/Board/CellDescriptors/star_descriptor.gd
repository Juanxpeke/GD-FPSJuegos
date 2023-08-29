class_name StarDescriptor
extends CellDescriptor

# Returns the set of cells only by a certain index
func _get_cells_by_index(origin_cell: Vector2i, index: int) -> Array:
	return [
		origin_cell + Vector2i(0, index),
		origin_cell + Vector2i(index, 0),
		origin_cell + Vector2i(0, -index),
		origin_cell + Vector2i(-index, 0),
		origin_cell + Vector2i(index, index),
		origin_cell + Vector2i(index, -index),
		origin_cell + Vector2i(-index, index),
		origin_cell + Vector2i(-index, -index)
	]
