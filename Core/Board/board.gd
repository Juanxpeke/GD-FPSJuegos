class_name Board
extends TileMap

var Layer : Dictionary = { "BOARD_LAYER":0, "HOLE_LAYER":1, "MOVEMENT_LAYER":2, "BASE_LAYER":3 , "BLOOD_LAYER":4 }

const TILES: Dictionary = {
	"board": Vector2i(1, 1),
	"board_alt": Vector2i(1, 2),
	"movement": Vector2i(10, 0),
	"base": Vector2i(10, 1),
	"blood": Vector2i(10, 9),
}

var units: Array[Unit] = []

# Private

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	GameManager.set_board(self)
	GameManager.map_initialized.connect(_on_map_initialized)
	
	_init_board_layer()

# Called when map is initialized
func _on_map_initialized() -> void:
	GameManager.map.preparation_ended.connect(_on_preparation_ended)
	GameManager.map.turn_ended.connect(_on_turn_ended)
	GameManager.map.game_changed.connect(_on_turn_ended)
	GameManager.map.match_ended.connect(_on_match_ended)

# Called when the preparation ends
func _on_preparation_ended() -> void:
	hide_base_cells()

# Called when the turn advances
func _on_turn_ended() -> void:
	hide_movement_cells()
	
# Called when the match ends
func _on_match_ended() -> void:
	hide_movement_cells()
	show_base_cells()
	clear_layer(Layer.BLOOD_LAYER)
	

# Initializes the board layer (just aesthetically) 
func _init_board_layer() -> void:
	for cell in get_used_cells(Layer.BOARD_LAYER):
		if ((cell[0] + cell[1]) % 2 != 0):
			set_cell(Layer.BOARD_LAYER, cell, 0, TILES.board_alt)

# DEPRECATED

# Returns an array with the cells in the discrete line from (x0, y0) to (x1, y1)
# Low part of modified Dofus' line algorithm
func _get_cells_line_low(x0: int, y0: int, x1: int, y1: int) -> Array:
	var cells_line = []
	var dx: int = x1 - x0
	var dy: int = y1 - y0
	var yi: int = 1
	
	if dy < 0:
		yi = -1
		dy = -dy
		
	var D: int = dy - dx
	var y: int = y0

	for x in range(x0, x1 + 1):
		cells_line.append(Vector2i(x, y))
		if D > 0:
			cells_line.append(Vector2i(x, y + yi))
			y = y + yi
			D = D + (2 * (dy - dx))
		elif D < 0:
			D = D + 2 * dy
		else:
			y = y + yi
			D = D + (2 * (dy - dx))
			
	return cells_line

# Returns an array with the cells in the discrete line from (x0, y0) to (x1, y1)
# High part of modified Dofus' line algorithm
func _get_cells_line_high(x0: int, y0: int, x1: int, y1: int) -> Array:
	var cells_line = []
	var dx: int = x1 - x0
	var dy: int = y1 - y0
	var xi: int = 1
	
	if dx < 0:
		xi = -1
		dx = -dx

	var D: int = dx - dy
	var x: int = x0

	for y in range(y0, y1 + 1):
		cells_line.append(Vector2i(x, y))
		if D > 0:
			cells_line.append(Vector2i(x + xi, y))
			x = x + xi
			D = D + (2 * (dx - dy))
		elif D < 0:
			D = D + 2 * dx
		else:
			x = x + xi
			D = D + (2 * (dx - dy))
			
	return cells_line

# Returns an array with the cells in the discrete line from start_cell to end_cell
# It uses a modified version of the Bresenham's line algorithm divided in different
# cases, trying to replicate the Dofus' behaviour
func _get_cells_line(start_cell: Vector2i, end_cell: Vector2i) -> Array:
	var x0: int = start_cell[0]
	var y0: int = start_cell[1]
	var x1: int = end_cell[0]
	var y1: int = end_cell[1]
	
	if abs(y1 - y0) < abs(x1 - x0):
		if x0 > x1:
			return _get_cells_line_low(x1, y1, x0, y0)
		else:
			return _get_cells_line_low(x0, y0, x1, y1)
	else:
		if y0 > y1:
			return _get_cells_line_high(x1, y1, x0, y0)
		else:
			return _get_cells_line_high(x0, y0, x1, y1)

# END DEPRECATED

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


# Public

# Gets the cell size
func get_cell_size() -> Vector2:
	return tile_set.tile_size

# Gets the cell from a given position
func get_cell(cell_position: Vector2) -> Vector2i:
	return local_to_map(to_local(cell_position))
	
# Gets the cell origin in global coordinates
func get_cell_origin(cell: Vector2i) -> Vector2:
	return to_global(map_to_local(cell)) - get_cell_size() / 2
	
# Gets the cell origin in global coordinates, given a position
func get_cell_originp(cell_position: Vector2) -> Vector2:
	return get_cell_origin(get_cell(cell_position))

# Gets the cell origin in local coordinates
func get_cell_local_origin(cell: Vector2i) -> Vector2:
	return map_to_local(cell) - get_cell_size() / 2
	
# Gets the cell center in global coordinates
func get_cell_center(cell: Vector2i) -> Vector2:
	return to_global(map_to_local(cell))

# Gets the cell center in global coordinates, given a position
func get_cell_centerp(cell_position: Vector2) -> Vector2:
	return get_cell_center(get_cell(cell_position))
	
# Get the max range of cells
func get_max_cell_range() -> int:
	var board_cells_size := get_used_rect().size
	return max(board_cells_size.x, board_cells_size.y)
	
# Filter the given cells by free cells
func get_free_cells(cell_descriptor: CellDescriptor, origin_cell := Vector2i(0, 0), mirrored := false) -> Array:
	var free_cells := []
	var board_cells := get_used_cells(Layer.BOARD_LAYER)
	var hole_cells := get_used_cells(Layer.HOLE_LAYER)
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
			
			if cell in hole_cells:
				if is_blockable:
					break
				else:
					continue
			
			if not cell in board_cells:
				cell = Vector2i(
					cell.x + (board_size.x if cell.x <= rect.position.x else -board_size.x) * int(cell_descriptor.wrap_around),
				 	cell.y + (board_size.y if cell.y <= rect.position.y else -board_size.y) * int(cell_descriptor.wrap_around_v)
				)
				
				#print(cell, board_sizex)
				if cell.y >= rect.end.y - 1 or cell.y <= rect.position.y or cell.x >= rect.end.x - 1 or cell.x <= rect.position.x:
					break
					
			
			if not is_blockable:
				free_cells.append(cell)
				continue
			
			
			for unit in units:
				var unit_cell := get_cell(unit.global_position)
					
				if unit_cell == cell:
					is_line_blocked = true
					break
			
			free_cells.append(cell)

			if is_line_blocked:
				break
	
	return free_cells

# Shows the movement cells
func show_movement_cells(cells: Array) -> void:
	for cell in cells:
		set_cell(Layer.MOVEMENT_LAYER, cell, 0, TILES.movement)

# Hides the movement cells
func hide_movement_cells() -> void:
	clear_layer(Layer.MOVEMENT_LAYER)
	
# Gets the base cells
func get_base_cells() -> Array[Vector2i]:
	return get_used_cells(Layer.BASE_LAYER)
	
# Shows the base cells
func show_base_cells() -> void:
	set_layer_enabled(Layer.BASE_LAYER, true)

# Hides the base cells
func hide_base_cells() -> void:
	set_layer_enabled(Layer.BASE_LAYER, false)
	
# Gets the mirrored cell of the given cell
func get_mirror_cell(cell: Vector2i) -> Vector2i:
	var rect = get_used_rect()
	var distance_corner = cell - rect.position
	var mirror_position = rect.end - distance_corner - Vector2i(1, 1)
	return mirror_position
	
# Gets the mirrored position of the given position
func get_mirror_position(cell_position: Vector2) -> Vector2:
	var mirror_position = get_cell_center(get_mirror_cell(get_cell(cell_position)))
	return mirror_position

# Adds a unit to the unit list
func add_unit(unit: Unit) -> void:
	units.append(unit)
	unit.tree_exited.connect(func(): remove_unit(unit))
	unit.has_dead.connect(func(): remove_unit(unit))
	unit.has_revived.connect(func(): readd_unit(unit))

# Readds a unit
func readd_unit(unit: Unit) -> void:
	units.append(unit)
	
# Removes a unit from the unit list
func remove_unit(unit: Unit) -> void:
	units.erase(unit)

func show_blood_cell(cell: Vector2i) -> void:
	set_cell(Layer.BLOOD_LAYER, cell, 0, TILES.blood)
