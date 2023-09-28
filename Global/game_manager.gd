extends Node

signal board_initialized
signal board_destroyed
signal map_initialized
signal map_destroyed

enum RoleEnum {
	NONE,
	ROLE_A,
	ROLE_B
}

var board: Board
var map: Map
var store: Store
var turn: int = 0

var units_scenes: Dictionary

# Private

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	units_scenes = {
		"king": load("res://Core/Units/king.tscn"),
		"bishop": load("res://Core/Units/bishop.tscn")
	}

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
	map_initialized.emit()
	
# Called to set the store
func set_store(store: Store) -> void:
	self.store = store
	
# Called to get the role parameters
func get_role(role_enum: RoleEnum) -> RolesManager.Role:
	return RolesManager.get_role(role_enum)
