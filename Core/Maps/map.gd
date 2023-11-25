class_name Map
extends Node2D

signal preparation_ended
signal turn_ended
signal player_turn_ended(player: Player)
signal match_ended
signal skill_activated

enum MatchPhase { PREPARATION, BATTLE, PAUSED }

@export var player_scene: PackedScene
@export var store_time: float = 7.0
@export var skill_picking_time: float = 26.0
@export var match_ending_time: float = 4.0

var map_rng: RandomNumberGenerator = RandomNumberGenerator.new()

var preparation_time: float = store_time

var first_turn_player_index: int = 0
var inner_first_turn_player_index: int = 0
var turn: int = 0
var matchi: int = 0

var match_phase: MatchPhase = MatchPhase.PREPARATION

var main_menu_scene: PackedScene = load("res://Core/UI/MainMenu/main_menu.tscn")

@onready var hud: HUD = %HUD
@onready var players: Node2D = %Players
@onready var king_marker: Marker2D = %KingMarker
@onready var multiplayer_synchronizer: MultiplayerSynchronizer = %MultiplayerSynchronizer

# Private

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	GameManager.set_map(self) # REVIEW: Skills need this to be here
	
	map_rng.randomize()
	
	for peer_player in MultiplayerManager.peer_players:
		var player = player_scene.instantiate()
		players.add_child(player)
		player.multiplayer_setup(peer_player)
		
	if players.get_child_count() == 2:
		players.get_child(0).enemy_player = players.get_child(1)
		players.get_child(1).enemy_player = players.get_child(0)

	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer_synchronizer.delta_synchronized.connect(_on_delta_synchronized)
	
	_start_preparation_phase()
#	if multiplayer.is_server():
#		var preparation_timer = get_tree().create_timer(preparation_time)
#		preparation_timer.timeout.connect(_on_preparation_timeout)
		# first_turn_player_index = map_rng.randi_range(0, players.get_child_count() - 1)
		# inner_first_turn_player_index = first_turn_player_index

# Called when a peer disconnects
func _on_peer_disconnected(_id: int) -> void:
	multiplayer.multiplayer_peer.close()
	MultiplayerManager.peer_players = []
	get_tree().change_scene_to_packed(main_menu_scene)

# Called when a multiplayer synchronization occurs
func _on_delta_synchronized() -> void:
	MultiplayerManager.log_msg("delta synchronized
		FTPI: %d" % first_turn_player_index)
	inner_first_turn_player_index = first_turn_player_index
	
# Called when the preparation timer timeouts
func _on_preparation_timeout() -> void:
	end_preparation.rpc()

#### Phases  ####

# Starts the preparation phase
func _start_preparation_phase() -> void:
	match_phase = MatchPhase.PREPARATION
	GameManager.play_sound("start_match")
	if multiplayer.is_server():
		var preparation_timer = get_tree().create_timer(preparation_time)
		preparation_timer.timeout.connect(_on_preparation_timeout)

# Public

# Gets the initial king position
func get_initial_king_position() -> Vector2:
	return GameManager.board.get_cell_centerp(king_marker.global_position)
	
# Gets the player by the given index
func get_player_by_turn(turn: int) -> Player:
	var player_index = (turn + inner_first_turn_player_index) % players.get_children().size()
	return players.get_child(player_index)

# Gets the current turn player
func get_current_turn_player() -> Player:
	return get_player_by_turn(turn)

#### Phases ####

# Ends the preparation phase
@rpc("call_local", "reliable")
func end_preparation() -> void:
	MultiplayerManager.log_msg("end preparation")
	match_phase = MatchPhase.BATTLE
	preparation_ended.emit()

# Ends the turn
func end_turn(player: Player) -> void:
	if (match_phase != MatchPhase.BATTLE): return
	MultiplayerManager.log_msg("end turn")
	turn += 1
	turn_ended.emit()
	player_turn_ended.emit(player)
	
# Ends the current match
func end_match() -> void:
	match_phase = MatchPhase.PAUSED
	await get_tree().create_timer(match_ending_time).timeout
	
	MultiplayerManager.log_msg("end match %d" % matchi)
	
	if matchi in GameManager.skill_choosing_matchis:
		preparation_time = store_time + skill_picking_time
		hud.update_times()
		hud.show_skills()
	else:
		preparation_time = store_time
		hud.update_times()
			
	_start_preparation_phase()
	
	inner_first_turn_player_index = (inner_first_turn_player_index + 1) % players.get_children().size()
	turn = 0
	matchi += 1
	
	match_ended.emit()

func get_players() -> Array[Node]:
	return players.get_children()
