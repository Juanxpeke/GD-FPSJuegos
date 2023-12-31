extends Node

signal board_initialized
signal board_destroyed
signal map_initialized
signal map_destroyed
signal activate_skill
signal player_initialized
signal player_destroyed

enum RoleEnum {
	NONE,
	ROLE_A,
	ROLE_B
}

var board: Board
var map: Map
var turn: int = 0
var store: Store
var player: Player # Myself

var units_data: Dictionary

var phase_matchi_changes: Dictionary = {
	"early": 0,
	"middle": 1,
	"late": 99,
}

var phase_damages: Dictionary = {
	"early": 2,
	"middle": 9,
	"late": 10,
}

# Private

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	units_data = {
		"king": load("res://Global/UnitData/king.tres"),
		"bishop": load("res://Global/UnitData/bishop.tres"),
		"knight": load("res://Global/UnitData/knight.tres"),
		"mage": load("res://Global/UnitData/mage.tres"),
		"jumper": load("res://Global/UnitData/jumper.tres"),
	}

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
	
# Called to set the player
func set_player(player: Player) -> void:
	self.player = player
	player_initialized.emit()

# Gets the current game phase
func get_phase() -> String:
	var game_phase = "early"
	
	if not map:
		print("game phase is ", game_phase, " ", multiplayer.get_unique_id())
		return game_phase
	
	for phase in phase_matchi_changes.keys():
		if phase_matchi_changes[phase] <= map.matchi:
			game_phase = phase
	
	print("game phase is ", game_phase, " ", multiplayer.get_unique_id())
	return game_phase

# Ends the game
func end_game() -> void:
	get_tree().change_scene_to_packed(load("res://Core/UI/HUD/GameOver/game_over.tscn"))
