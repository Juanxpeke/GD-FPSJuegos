class_name CellDescriptor
extends Resource
# Parent class for cell descriptors

# Range -1 implies infinite range, that in practice is board size. If there exists
# board size changes we must implement a signal logic for infinite range units
@export var is_blockable: bool = true
@export var is_filled: bool = true
@export var cell_range: int = -1

var wrap_around: bool = false # se usa solamente para 1 skill lol
# Private

var _directions: Array[Array] = [] 

var _base_movement: Array[Vector2i] = []

# Constructor
func _init() -> void:
	GameManager.connect("board_initialized", _on_board_initialized)

# Called when the game board is initialized
func _on_board_initialized() -> void:
	if cell_range == -1:
		cell_range = GameManager.board.get_max_cell_range()

# Public

func get_directions() -> Array[Array]:
	return _directions

func get_base_movement() -> Array[Vector2i]:
	return _base_movement
	
# Returns the set of cells only by a certain index
func _get_cells_by_index(origin_cell: Vector2i, index: int) -> Array[Vector2i]:
	return []

# Returns the set of cells that describe this descriptor
func get_cells(origin_cell: Vector2i) -> Array:
	var cells := []
	var initial_cell_index = 0 if is_filled else cell_range - 1
	
	for i in range(initial_cell_index, cell_range):
		cells = cells + _get_cells_by_index(origin_cell, i + 1)
	
	return cells

