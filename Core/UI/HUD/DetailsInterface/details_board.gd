extends TileMap

var unit: Unit

var Layer : Dictionary = { "BOARD_LAYER":0, "MOVEMENT_LAYER":1 }

const TILES: Dictionary = {
	"board": Vector2i(1, 1),
	"board_alt": Vector2i(1, 2),
	"movement": Vector2i(10, 0),
	"base": Vector2i(10, 1),
	"blood": Vector2i(10, 9),
}

# Private

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	pass # Replace with function body

# Gets the lines related to the given cell descriptor
func _get_lines_from_cell_descriptor(cell_descriptor: CellDescriptor, origin_cell: Vector2i) -> Array[Array]:
	var result: Array[Array] = []
	var directions: Array[Array] = cell_descriptor.get_directions()
	var initial_cell_index = 0 if cell_descriptor.is_filled else cell_descriptor.cell_range - 1
	var base_movements: Array[Vector2i] = cell_descriptor.get_base_movement()
	
	for i in range(0, directions.size()):
		var line = []
		var direction = directions[i]
		var dir_size = direction.size()
		var last_cell: Vector2i = origin_cell + base_movements[i] if (base_movements.size() > i) else origin_cell
		
		for index in range(0, cell_descriptor.cell_range):
			last_cell += direction[index % dir_size]
			if index >= initial_cell_index:
				line.append(last_cell)
			
		result.append(line)
	return result

# Filter the given cells by free cells
func _get_free_cells(cell_descriptor: CellDescriptor, origin_cell := Vector2i(0, 0), mirrored := false) -> Array:
	var free_cells := []
	var is_blockable = cell_descriptor.is_blockable
	var lines = _get_lines_from_cell_descriptor(cell_descriptor, origin_cell)
	
	var rect = get_used_rect()
	var board_size = rect.size - Vector2i(2, 2)
	
	for line in lines:
		var is_line_blocked := false
		for cell in line:
			
			if mirrored:
				cell.x = 2 * origin_cell.x - cell.x
				cell.y = 2 * origin_cell.y - cell.y
					
			
			if not is_blockable:
				free_cells.append(cell)
				continue
			
			free_cells.append(cell)

			if is_line_blocked:
				break
	
	return free_cells

# Shows the movement cells
func _show_movement_cells(cells: Array) -> void:
	for cell in cells:
		set_cell(Layer.MOVEMENT_LAYER, cell, 0, TILES.movement)

# Public

# Sets the unit
func set_unit(unit: Unit) -> void:
	clear_layer(Layer.MOVEMENT_LAYER)
	var cells_to_show = []
	for cell_descriptor in unit.level_1_descriptors:
		cells_to_show += _get_free_cells(cell_descriptor, Vector2i(3, 3))
	_show_movement_cells(cells_to_show)
