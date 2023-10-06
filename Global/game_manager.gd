extends Node

signal board_initialized
signal board_destroyed
signal map_initialized
signal map_destroyed
signal activate_skill
signal player_initialized

enum RoleEnum {
	NONE,
	ROLE_A,
	ROLE_B
}

var board: Board
var map: Map
var turn: int = 0
var player: Player #myself

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
	
# Called to get the role parameters
func get_role(role_enum: RoleEnum) -> RolesManager.Role:
	return RolesManager.get_role(role_enum)
	
	
# Called to set the player
func set_player(player: Player) -> void:
	self.player = player
	player_initialized.emit()
