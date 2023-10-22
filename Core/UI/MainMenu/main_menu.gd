extends MarginContainer

const MAX_PLAYERS = 2
const PORT = 5409

@export var game_map_scene: PackedScene
@export var lobby_player_scene: PackedScene

var _menu_stack: Array[Control] = []

@onready var user = %User
@onready var host = %Host
@onready var join = %Join

@onready var ip = %IP
@onready var back_join: Button = %BackJoin
@onready var confirm_join: Button = %ConfirmJoin

@onready var menus: MarginContainer = %Menus

@onready var start_menu = %StartMenu
@onready var join_menu = %JoinMenu


# Private

# Called when the node enters the scene tree
func _ready():
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	
	host.pressed.connect(_on_host_pressed)
	join.pressed.connect(_on_join_pressed)
	
	confirm_join.pressed.connect(_on_confirm_join_pressed)
	
	back_join.pressed.connect(_back_menu)

	_go_to_menu(start_menu)
	
	user.text = OS.get_environment("USERNAME") + (str(randi() % 1000) if Engine.is_editor_hint()
 else "")
	
	# MultiplayerManager.upnp_completed.connect(_on_upnp_completed)

# Called when UPNP is completed
func _on_upnp_completed(status) -> void:
	print(status, "lalala")
	if status == OK:
		print("Port Opened", 5)
	else:
		print("Port Error", 5)


func _on_host_pressed() -> void:
	var peer = ENetMultiplayerPeer.new()
	
	var err = peer.create_server(PORT, MAX_PLAYERS)
	if err:
		print("Host Error: %d" %err)
		return
	
	multiplayer.multiplayer_peer = peer
	
	var player = MultiplayerManager.PeerPlayer.new(multiplayer.get_unique_id(), user.text)
	MultiplayerManager.add_peer_player(player)
	
	# _go_to_menu(ready_menu)


func _on_join_pressed() -> void:
	_go_to_menu(join_menu)


func _on_confirm_join_pressed() -> void:
	var peer = ENetMultiplayerPeer.new()
	var err = peer.create_client(ip.text, PORT)
	if err:
		print("Host Error: %d" %err)
		return
	
	multiplayer.multiplayer_peer = peer
	
	var player = MultiplayerManager.PeerPlayer.new(multiplayer.get_unique_id(), user.text)
	MultiplayerManager.add_peer_player(player)
	
	# _go_to_menu(ready_menu)


func _on_connected_to_server() -> void:
	print("connected_to_server")


func _on_connection_failed() -> void:
	print("connection_failed")


func _on_peer_connected(id: int) -> void:
	print("peer_connected %d" % id)
	
	send_info.rpc_id(id, MultiplayerManager.get_current_peer_player().to_dict())
	var local_id = multiplayer.get_unique_id()
	if multiplayer.is_server():
		for player_id in status:
			set_player_ready.rpc_id(id, player_id, status[player_id])
		status[id] = false


func _on_peer_disconnected(id: int) -> void:
	print("peer_disconnected %d" % id)
	_remove_player(id)
	if multiplayer.is_server():
		starting_game.rpc(false)
	
	# Server closed connection
	if id == 1:
		_back_menu()


func _on_server_disconnected() -> void:
	print("server_disconnected")


func _remove_player(id: int):
	var lobby_player = lobby_players.find_child(str(id), true, false)
	lobby_players.remove_child(lobby_player)
	lobby_player.queue_free()
	status.erase(id)
	MultiplayerManager.remove_peer_player(id)




@rpc("any_peer", "reliable")
func send_info(info_dict: Dictionary) -> void:
	var player = MultiplayerManager.PeerPlayer.new(info_dict.id, info_dict.name, info_dict.role)
	MultiplayerManager.add_peer_player(player)


func _paint_ready(id: int) -> void:
	for child in lobby_players.get_children():
		if child.name == str(id):
			child.modulate = Color.GREEN_YELLOW
			

func _disconnect():
	multiplayer.multiplayer_peer.close()
	
	for lobby_player in lobby_players.get_children():
		lobby_players.remove_child(lobby_player)
		lobby_player.queue_free()
	
	ready_toggle.disabled = true
	status = { 1 : false }
	MultiplayerManager.peer_players = []

func _hide_menus():
	for child in menus.get_children():
		child.hide()


func _go_to_menu(menu: Control) -> void:
	_hide_menus()
	_menu_stack.push_back(menu)
	menu.show()


func _back_menu() -> void:
	_hide_menus()
	_menu_stack.pop_back()
	var menu = _menu_stack.back()
	if menu:
		menu.show()
	_disconnect()


func _back_to_first_menu() -> void:
	var first = _menu_stack.front()
	_menu_stack.clear()
	if first:
		_menu_stack.push_back(first)
		first.show()
	if MultiplayerManager.is_online():
		_disconnect()
