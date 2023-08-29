class_name Player
extends Node2D

@export var initial_unit_scene: PackedScene

# Public

# Sets up the multiplayer data for the player node
func multiplayer_setup(peer_player: MultiplayerManager.PeerPlayer, peer_position: Vector2):
	name = str(peer_player.id)
	
	var initial_unit = initial_unit_scene.instantiate()
	add_child(initial_unit)
	
	initial_unit.name = "random" + str(peer_player.id)
	initial_unit.position = peer_position
	
	set_multiplayer_authority(peer_player.id)
