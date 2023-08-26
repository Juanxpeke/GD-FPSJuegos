class_name CellDescriptor
extends Resource
# Parent class for cell descriptors

# Range -1 implies infinite range, that in practice is board size. If there exists
# board size changes we must implement a signal logic for infinite range units
@export var is_blockable: bool = true
@export var is_filled: bool = true
@export var cell_range: int = -1

# Private

# Constructor
func _init() -> void:
	GameManager.connect("board_initialized", _on_board_initialized)

# Called when the game board is initialized
func _on_board_initialized() -> void:
	if cell_range == -1:
		cell_range = GameManager.board.get_max_cell_range()

# Public

# Returns the set of cells only by a certain index
func get_cells_by_index(origin_cell: Vector2i, index: int) -> Array[Vector2i]:
	return []

# Returns the set of cells that describe this descriptor
func get_cells(origin_cell: Vector2i) -> Array[Vector2i]:
	return []
