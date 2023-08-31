class_name Player
extends Node2D

@export var king_unit_scene: PackedScene

# Public

# Sets up the multiplayer data for the player node
func multiplayer_setup(peer_player: MultiplayerManager.PeerPlayer):
	name = "Player" + str(peer_player.id)
		
	var king_unit = king_unit_scene.instantiate()
	add_child(king_unit)
	
	king_unit.name = "King" + str(peer_player.id)
	
	if multiplayer.get_unique_id() == peer_player.id:
		king_unit.position = GameManager.map.get_initial_king_position()
	else:
		king_unit.position = GameManager.board.get_mirror_position(GameManager.map.get_initial_king_position())
	
	set_multiplayer_authority(peer_player.id)
