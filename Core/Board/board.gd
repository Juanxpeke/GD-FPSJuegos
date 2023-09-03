class_name Board
extends TileMap

enum Layer { BOARD_LAYER, HOLE_LAYER, MOVEMENT_LAYER }
enum Tile { BOARD_TILE, ALT_BOARD_TILE, HOLE_TILE, MOVEMENT_TILE }

var units: Array[Unit] = []

# Private

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	GameManager.set_board(self)
	GameManager.connect("game_changed", _on_game_changed)
	
	_init_board_layer()

# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(_delta: float) -> void:
	pass
	
# Called when the game changes
func _on_game_changed() -> void:
	hide_movement_cells()

# Initializes the board layer (just aesthetically) 
func _init_board_layer() -> void:
	for cell in get_used_cells(Layer.BOARD_LAYER):
		if ((cell[0] + cell[1]) % 2 != 0):
			set_cell(Layer.BOARD_LAYER, cell, Tile.ALT_BOARD_TILE, Vector2i(0, 0))

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

# Public

# Gets the cell from a given position
func get_cell(cell_position: Vector2) -> Vector2i:
	return local_to_map(to_local(cell_position))

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
func get_free_cells(cells: Array, origin_cell := Vector2i(0, 0), is_blockable := true) -> Array:
	var free_cells := []
	var board_cells := get_used_cells(Layer.BOARD_LAYER)
	var hole_cells := get_used_cells(Layer.HOLE_LAYER)
	
	for cell in cells:
		var is_cell_blocked := false
		
		if not cell in board_cells:
			continue
		
		if not is_blockable:
			free_cells.append(cell)
			continue
		
		var cells_line := _get_cells_line(origin_cell, cell)
		
		for unit in units:
			var unit_cell := get_cell(unit.global_position)
				
			if unit_cell in cells_line and unit_cell != origin_cell and unit_cell != cell:
				is_cell_blocked = true
				break
				
		for hole_cell in hole_cells:
			if hole_cell in cells_line:
				is_cell_blocked = true
				break

		if not is_cell_blocked:
			free_cells.append(cell)
	
	return free_cells

# Shows the movement cells
func show_movement_cells(cells: Array) -> void:
	# TODO caso peon con distinto ataque y movimiento se ignora
	for cell in cells:
		set_cell(Layer.MOVEMENT_LAYER, cell, Tile.MOVEMENT_TILE, Vector2i(0, 0))

# Hides the movement cells
func hide_movement_cells() -> void:
	clear_layer(Layer.MOVEMENT_LAYER)
	
# Gets the vertical mirrored position of the given position
func get_mirror_position(cell_position: Vector2) -> Vector2:
	var mirror_position = to_global(to_local(cell_position) * -1)
	return mirror_position

# Adds a unit to the unit list
func add_unit(unit: Unit) -> void:
	units.append(unit)
	unit.connect("tree_exiting", func(): remove_unit(unit))

# Removes a unit from the unit list
func remove_unit(unit: Unit) -> void:
	units.erase(unit)
