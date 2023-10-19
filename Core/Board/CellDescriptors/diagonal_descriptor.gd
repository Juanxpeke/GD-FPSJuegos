class_name DiagonalDescriptor
extends CellDescriptor

func _init() -> void:
	super._init()
	_directions = [
		[Vector2i(1, 1)],
		[Vector2i(1, -1)],
		[Vector2i(-1, 1)],
		[Vector2i(-1, -1)]
	]


# Returns the set of cells only by a certain index
func _get_cells_by_index(origin_cell: Vector2i, index: int) -> Array:
	return [
		origin_cell + Vector2i(index, index),
		origin_cell + Vector2i(index, -index),
		origin_cell + Vector2i(-index, index),
		origin_cell + Vector2i(-index, -index)
	]
