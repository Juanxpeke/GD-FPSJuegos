extends Node

signal board_initialized
signal board_destroyed
signal turn_ended
signal game_changed # Called on ANY game change

var board: Board
var map: Map
var turn: int = 0

# This has to be changed to a set of classes
var roles_parameters: Array = [
	
]

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
	
# Called to get the role parameters
func get_role_parameters(role: MultiplayerManager.Role) -> void:
	pass
