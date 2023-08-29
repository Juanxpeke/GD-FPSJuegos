extends Node

signal peer_players_updated
signal peer_player_updated(id: int)

enum Role {
	NONE,
	ROLE_A,
	ROLE_B
}

const SERVER_PORT: int = 5049

var thread: Thread

# [ { id: int, name: string, rol: Role } ]
var peer_players: Array[PeerPlayer] = []

# Private

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	thread = Thread.new()
	thread.start(_upnp_setup.bind(SERVER_PORT))

# Sets up the UPNP port forwarding
func _upnp_setup(server_port) -> void:
	# UPNP queries take some time
	var upnp = UPNP.new()
	var err = upnp.discover()
	
	if err != OK:
		push_error(str(err))
		return

	var gateway = upnp.get_gateway()
	if gateway and gateway.is_valid_gateway():
		upnp.add_port_mapping(server_port, server_port, ProjectSettings.get_setting("application/config/name"), "UDP")
		upnp.add_port_mapping(server_port, server_port, ProjectSettings.get_setting("application/config/name"), "TCP")

# Called when the node is going to exit the scene tree
func _exit_tree() -> void:
	# Wait for thread finish here to handle game exit while the thread is running
	thread.wait_to_finish()

# Public

# ===========
# Multiplayer
# ===========

# Sorts the peer players so each peer has the same order
func sort_peer_players() -> void:
	peer_players.sort_custom(func (a, b): return a.id < b.id)

# Adds a peer player to the peer players data
func add_peer_player(peer_player: PeerPlayer) -> void:
	peer_players.append(peer_player)
	peer_players_updated.emit()

# Removes a peer player from the peer players data
func remove_peer_player(id: int) -> void:
	for i in peer_players.size():
		if peer_players[i].id == id:
			peer_players.remove_at(i)
			break
	peer_players_updated.emit()

# Gets a peer player given the peer player multiplayer ID
func get_peer_player(id: int) -> PeerPlayer:
	for peer_player in peer_players:
		if peer_player.id == id:
			return peer_player
	return null

# Gets the current peer player
func get_current_peer_player() -> PeerPlayer:
	return get_peer_player(multiplayer.get_unique_id())

# Sets the given role to the player with the given multiplayer ID
@rpc("any_peer", "reliable", "call_local")
func set_peer_player_role(id: int, role: Role) -> void:
	var player = get_peer_player(id)
	player.role = role
	peer_player_updated.emit(id)

# Sets the given role to the current player
func set_current_peer_player_role(role: Role) -> void:
	set_peer_player_role.rpc(multiplayer.get_unique_id(), role)

# Returns true if the current player is online, false otherwise
func is_online() -> bool:
	return not multiplayer.multiplayer_peer is OfflineMultiplayerPeer and \
		multiplayer.multiplayer_peer.get_connection_status() != MultiplayerPeer.CONNECTION_DISCONNECTED


# Class for representing the online shared player data
class PeerPlayer:
	var id: int
	var name: String
	var role: Role
	
	# Constructor
	func _init(new_id: int, new_name: String, new_role: Role = Role.NONE) -> void:
		id = new_id
		name = new_name
		role = new_role
	
	# Returns a dictionary with the data
	func to_dict() -> Dictionary:
		return {
			"id": id,
			"name": name,
			"role": role
		}
