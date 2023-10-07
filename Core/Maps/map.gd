class_name Map
extends Node2D

signal store_ended
signal turn_ended
signal match_ended
signal game_changed

enum MatchPhase { STORE, BATTLE }

@export var player_scene: PackedScene
@export var preparation_time: float = 10.0
@export var first_turn_player_index: int = 0 # TODO: Remove @export

var skill_picker_scene : PackedScene = preload("res://Core/Players/Skills/skill_picker.tscn")

var map_rng: RandomNumberGenerator = RandomNumberGenerator.new()

var turn: int = 0
var matchi: int = 0

var match_phase: MatchPhase = MatchPhase.STORE

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

	multiplayer_synchronizer.connect("delta_synchronized", _on_delta_synchronized)
	
	if multiplayer.is_server():
		var preparation_timer = get_tree().create_timer(preparation_time)
		preparation_timer.timeout.connect(_on_preparation_timeout)
		first_turn_player_index = map_rng.randi_range(0, players.get_child_count() - 1)

# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(delta: float) -> void:
	pass

# Called when a multiplayer synchronization occurs
func _on_delta_synchronized() -> void:
	print("delta_synchronized")
	print("\tFTPI: ", first_turn_player_index)
	
# Called when the store timer timeouts
func _on_preparation_timeout() -> void:
	end_store.rpc()

# Public

# Gets the initial king position
func get_initial_king_position() -> Vector2:
	return GameManager.board.get_cell_centerp(king_marker.position)
	
# Gets the player by the given index
func get_player_by_turn(turn: int) -> Player:
	var player_index = (turn + first_turn_player_index) % players.get_children().size()
	return players.get_child(player_index)

# Gets the current turn player
func get_current_turn_player() -> Player:
	return get_player_by_turn(turn)

# Ends the store phase
@rpc("call_local", "reliable")
func end_store() -> void:
	print("end_store ", multiplayer.get_unique_id())
	match_phase = MatchPhase.BATTLE
	store_ended.emit()

# Ends the turn
func end_turn() -> void:
	if (match_phase != MatchPhase.BATTLE): return
	print("end_turn ", multiplayer.get_unique_id())
	turn += 1
	turn_ended.emit()
	
# Ends the current match
func end_match() -> void:
	print("end_match ", multiplayer.get_unique_id())
	match_phase = MatchPhase.STORE
	
	if multiplayer.is_server():
		var preparation_timer = get_tree().create_timer(preparation_time)
		preparation_timer.timeout.connect(_on_preparation_timeout)
		first_turn_player_index = (first_turn_player_index + 1) % players.get_children().size()
	
	turn = 0
	matchi += 1
	
	var skill_picker = skill_picker_scene.instantiate()
	add_child(skill_picker)
	
	match_ended.emit()
	
