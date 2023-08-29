class_name Player
extends Node2D


func setup(peer_player: MultiplayerManager.PeerPlayer):
	set_multiplayer_authority(peer_player.id)
	name = str(peer_player.id)
	print(peer_player.name, 30)
	print(peer_player.role, 30)


func _input(event: InputEvent) -> void:
	if is_multiplayer_authority():
		if event.is_action_pressed("test"):
			test.rpc_id(1)

@rpc
func test():
#	if is_multiplayer_authority():
	print("test - player: %s" % name, 30)
