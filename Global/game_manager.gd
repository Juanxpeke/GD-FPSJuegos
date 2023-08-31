extends Node

signal board_initialized
signal board_destroyed
signal game_changed # Called on ANY game change

var board: Board
var map: Map
var turn: int = 0

# Private

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(delta: float) -> void:
	pass

# Public

# Called to set the board
func set_board(board: Board) -> void:
	self.board = board
	board_initialized.emit()
	
# Called to set the map
func set_map(map: Map) -> void:
	self.map = map
