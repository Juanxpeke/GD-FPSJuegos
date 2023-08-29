class_name CompositeDescriptor
extends CellDescriptor

@export var inner_descriptors: Array[CellDescriptor]

# Returns the set of cells only by a certain index
func _get_cells_by_index(origin_cell: Vector2i, index: int) -> Array:
	var cells = []
	
	for inner_descriptor in inner_descriptors:
		var inner_cells = inner_descriptor._get_cells_by_index(origin_cell, index)
		
		for inner_cell in inner_cells:
			if not inner_cell in cells:
				cells.append(inner_cell)
	
	return cells
