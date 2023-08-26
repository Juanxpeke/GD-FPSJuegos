class_name LineDescriptor
extends CellDescriptor

# Returns the set of cells only by a certain index
func get_cells_by_index(origin_cell: Vector2i, index: int) -> Array:
	return [
		origin_cell + Vector2i(0, index),
		origin_cell + Vector2i(index, 0),
		origin_cell + Vector2i(0, -index),
		origin_cell + Vector2i(-index, 0)
	]

# Returns the set of cells that describe this descriptor
func get_cells(origin_cell: Vector2i) -> Array:
	var cells := []
	var initial_cell_index = 0 if is_filled else cell_range - 1
	
	for i in range(initial_cell_index, cell_range):
		cells = cells + get_cells_by_index(origin_cell, i + 1)
	
	return cells
