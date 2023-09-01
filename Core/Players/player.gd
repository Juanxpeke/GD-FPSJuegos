class_name Player
extends Node2D

@export var king_unit_scene: PackedScene
var enemy_player : Player

var pieces_scenes: Dictionary = {
	"king": "res://Core/Units/king.tscn",
	"bishop": "res://Core/Units/bishop.tscn",
}
var position_unit_array: Array[Array] = [
	["king", Vector2(0, 0)],
	["bishop", Vector2(-30, 0)],
	["bishop", Vector2(30, 0)],
]
# Public

# Sets up the multiplayer data for the player node
func multiplayer_setup(peer_player: MultiplayerManager.PeerPlayer):
	name = "Player" + str(peer_player.id)
	for i in range(position_unit_array.size()):
		var offset = position_unit_array[i][1]
		var piece_name = position_unit_array[i][0]
		var king_unit = load(pieces_scenes[piece_name]).instantiate() # cant preload as cell_descriptors get added before GameManager
		
		add_child(king_unit)
		
		king_unit.name = str(i) + str(peer_player.id)
		
		if multiplayer.get_unique_id() == peer_player.id:
			king_unit.position = GameManager.map.get_initial_king_position() + offset
		else:
			king_unit.position = GameManager.board.get_mirror_position(GameManager.map.get_initial_king_position() + offset)
		
	set_multiplayer_authority(peer_player.id)
	GameManager.set_board(GameManager.board) # unit's cell_descriptors aren't updating as board was set before
