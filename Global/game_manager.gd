extends Node

signal board_initialized
signal board_destroyed
signal map_initialized
signal map_destroyed
signal activate_skill
signal player_initialized
signal player_destroyed

var board: Board
var map: Map
var store: Store
var player: Player # Myself
var last_winner: MultiplayerManager.PeerPlayer

var turn: int = 0

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

var phase_rewards: Dictionary = {
	"early": 4,
	"middle": 7,
	"late": 12,
}

var skill_choosing_matchis: Array[int] = [0, 2, 5, 8]

var game_over_scene: PackedScene = load("res://Core/UI/GameOver/game_over.tscn")

# Private

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	units_data = {
		# Test units
		"knight": load("res://Global/UnitData/knight.tres"),
		# Real units
		"king": load("res://Global/UnitData/king.tres"),
		"queen": load("res://Global/UnitData/queen.tres"),
		"bishop": load("res://Global/UnitData/bishop.tres"),
		"rook": load("res://Global/UnitData/rook.tres"),
		"jumper": load("res://Global/UnitData/jumper.tres"),
		"mace": load("res://Global/UnitData/mace.tres"),
		"sniper": load("res://Global/UnitData/sniper.tres"),
		"ninja": load("res://Global/UnitData/ninja.tres"),
		"swordman": load("res://Global/UnitData/swordman.tres")
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
		MultiplayerManager.log_msg("game phase is %s" % game_phase)
		return game_phase
	
	for phase in phase_matchi_changes.keys():
		if phase_matchi_changes[phase] <= map.matchi:
			game_phase = phase
	
	MultiplayerManager.log_msg("game phase is %s" % game_phase)
	return game_phase

# Ends the game
func end_game(winner: MultiplayerManager.PeerPlayer) -> void:
	last_winner = winner
	
	MultiplayerManager.peer_players = []
	
	get_tree().change_scene_to_packed(game_over_scene)
