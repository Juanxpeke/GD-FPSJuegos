class_name Map
extends Node2D

@export var player_scene: PackedScene

var turn_index: int = 0
var rng: RandomNumberGenerator

var is_initial_turn: bool

@onready var players: Node2D = %Players
@onready var authority_marker: Marker2D = %AuthorityPosition
@onready var puppet_marker: Marker2D = %PuppetPosition

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	GameManager.set_map(self)
	
	for peer_player in MultiplayerManager.peer_players:
		var player = player_scene.instantiate()
		players.add_child(player)
	
		if multiplayer.get_unique_id() == peer_player.id:
			player.multiplayer_setup(peer_player, authority_marker.position)
		else:
			player.multiplayer_setup(peer_player, puppet_marker.position)
	
# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(delta: float) -> void:
	pass

# Public

# Gets the player by the given index
func get_player_by_index(index: int) -> Player:
	return players.get_child(index % players.get_children().size())

# Gets the current player by the turn index
func get_current_turn_player() -> Player:
	return get_player_by_index(turn_index)

# Changes the player in turn
func advance_turn() -> void:
	turn_index += 1
