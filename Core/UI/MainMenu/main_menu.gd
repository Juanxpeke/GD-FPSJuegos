extends MarginContainer

const MAX_PLAYERS = 2
const PORT = 5409

var _menu_stack: Array[Control] = []

@onready var matchmaking_button = %MatchmakingButton
@onready var exit_button = %ExitButton

@onready var username_input = %UsernameInput
@onready var host_button = %HostButton
@onready var join_button = %JoinButton
@onready var back_matchmaking_button: Button = %BackMatchmakingButton

@onready var ip_input = %IPInput
@onready var confirm_join_button: Button = %ConfirmJoinButton
@onready var back_join_button: Button = %BackJoinButton

@onready var menus: Control = %Menus

@onready var start_menu = %StartMenu
@onready var matchmaking_menu = %MatchmakingMenu
@onready var join_menu = %JoinMenu
@onready var lobby_menu = %LobbyMenu


# Private

# Called when the node enters the scene tree
func _ready():
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	
	matchmaking_button.pressed.connect(_on_matchmaking_button_pressed)
	exit_button.pressed.connect(_on_exit_button_pressed)
	
	host_button.pressed.connect(_on_host_button_pressed)
	join_button.pressed.connect(_on_join_button_pressed)
	back_matchmaking_button.pressed.connect(back_menu)
	
	confirm_join_button.pressed.connect(_on_confirm_join_button_pressed)
	back_join_button.pressed.connect(back_menu)
	

	_go_to_menu(start_menu)
	
	username_input.text = OS.get_environment("USERNAME") + (str(randi() % 1000) if Engine.is_editor_hint()
 else "")

# Called when UPNP is completed
func _on_upnp_completed(status) -> void:
	if status == OK:
		pass
	else:
		pass
		
# Called when matchmaking button is pressed
func _on_matchmaking_button_pressed() -> void:
	_go_to_menu(matchmaking_menu)
	
# Called when exit button is pressed
func _on_exit_button_pressed() -> void:
	get_tree().quit()

# Called when host button is pressed
func _on_host_button_pressed() -> void:
	var peer = ENetMultiplayerPeer.new()
	
	var err = peer.create_server(PORT, MAX_PLAYERS)
	if err:
		return
	
	multiplayer.multiplayer_peer = peer
	
	var player = MultiplayerManager.PeerPlayer.new(multiplayer.get_unique_id(), username_input.text)
	MultiplayerManager.add_peer_player(player)
	
	_go_to_menu(lobby_menu)

# Called when join button is pressed
func _on_join_button_pressed() -> void:
	_go_to_menu(join_menu)

# Called when confirm join button is pressed
func _on_confirm_join_button_pressed() -> void:
	var peer = ENetMultiplayerPeer.new()
	var err = peer.create_client(ip_input.text, PORT)
	if err:
		return
	
	multiplayer.multiplayer_peer = peer
	
	var player = MultiplayerManager.PeerPlayer.new(multiplayer.get_unique_id(), username_input.text)
	MultiplayerManager.add_peer_player(player)
	
	_go_to_menu(lobby_menu)

# Called when connected to server
func _on_connected_to_server() -> void:
	MultiplayerManager.log_msg("connected to server")

# Called when connection failed
func _on_connection_failed() -> void:
	MultiplayerManager.log_msg("connection failed")

# Called when server disconnects
func _on_server_disconnected() -> void:
	MultiplayerManager.log_msg("server disconnected")

# Hides all the menus
func _hide_menus():
	for child in menus.get_children():
		child.hide()

# Goes to the given menu
func _go_to_menu(menu: Control) -> void:
	_hide_menus()
	
	_menu_stack.push_back(menu)
	
	menu.show()

# Backs the menu queue
func back_menu() -> void:
	_hide_menus()
	
	_menu_stack.pop_back()
	
	var menu = _menu_stack.back()
	if menu:
		menu.show()
