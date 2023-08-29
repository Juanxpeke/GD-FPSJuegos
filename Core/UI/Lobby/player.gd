class_name Player
extends Node2D

var units: Array[Unit] = [King]

# Public

# Sets up the multiplayer data for the player node
func multiplayer_setup(peer_player: MultiplayerManager.PeerPlayer):
	set_multiplayer_authority(peer_player.id)
	name = str(peer_player.id)
