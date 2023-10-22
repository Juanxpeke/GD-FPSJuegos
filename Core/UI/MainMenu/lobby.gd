extends Control

@export var lobby_role_scene: PackedScene
@export var game_map_scene: PackedScene

var status = { 1 : false }

@onready var time_label := %TimeLabel
@onready var player_username := %PlayerUsername
@onready var enemy_username := %EnemyUsername
@onready var player_role_portrait := %PlayerRolePortrait
@onready var enemy_role_portrait := %EnemyRolePortrait
@onready var ready_button := %ReadyButton
@onready var back_button := %BackButton
@onready var roles_container := %RolesContainer
@onready var start_timer := %StartTimer

# Private

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	ready_button.disabled = true
	time_label.hide()
	
	ready_button.pressed.connect(_on_ready_toggled)
	start_timer.timeout.connect(_on_start_timer_timeout)	

	MultiplayerManager.peer_players_updated.connect(_on_peer_players_updated)
	MultiplayerManager.peer_player_updated.connect(_on_peer_player_updated)

# Called on each frame
func _process(delta: float) -> void:
	if !start_timer.is_stopped():
		time_label.text = str(ceil(start_timer.time_left))

# Called when a peer player is added or removed from the MultiplayerManager
func _on_peer_players_updated() -> void:
	_check_ready()

# Called when the given peer player is updated
func _on_peer_player_updated(id: int) -> void:
	_check_ready()
	
	if id == multiplayer.get_unique_id():
		_update_player_interface()
	else:
		_update_enemy_interface(id)

# Called when the ready buton is toggled
func _on_ready_toggled() -> void:
	toggle_player_ready_status.rpc_id(1, multiplayer.get_unique_id())
	
# Called when the start timer timeouts
func _on_start_timer_timeout() -> void:
	if multiplayer.is_server():
		start_game.rpc()
	
# Updates the player interface
func _update_player_interface() -> void:
	player_username.text = \
			MultiplayerManager.get_current_peer_player().name
	player_role_portrait.texture = \
			RolesManager.get_role(MultiplayerManager.get_current_peer_player().role_id).portrait
	
# Updates the enemy interface
func _update_enemy_interface(id: int) -> void:
	enemy_username.text = \
			MultiplayerManager.get_peer_player(id).name
	enemy_role_portrait.texture = \
			RolesManager.get_role(MultiplayerManager.get_peer_player(id).role_id).portrait
	
# Checks if the ready button can be enabled
func _check_ready() -> void:
	var roles = []
	for peer_player in MultiplayerManager.peer_players:
		if not peer_player.role_id in roles and peer_player.role_id != -1:
			roles.push_back(peer_player.role_id)
	ready_button.disabled = roles.size() != 2

# Public

# Toggles the player ready status
@rpc("reliable", "any_peer", "call_local")
func toggle_player_ready_status(id: int):
	if multiplayer.is_server():
		status[id] = !status[id]
		set_player_ready.rpc(id, status[id])
		
		var all_ok = true
		for ok in status.values():
			all_ok = all_ok and ok
			
		if all_ok:
			set_start_timer.rpc(true)
		else:
			set_start_timer.rpc(false)
			
@rpc("reliable", "any_peer", "call_local")
func set_player_ready(id: int, value: bool):
	#for child in lobby_players.get_children():
	#	var player = child as UILobbyPlayer
	#	if player.player_id == id:
	#		player.set_ready(value)
	pass

# Sets the start timer by the given value and modifies the related layout
@rpc("any_peer", "call_local", "reliable")
func set_start_timer(value: bool):
	back_button.disabled = value
	time_label.visible = value
	roles_container.visible = not value
	if value:
		start_timer.start()
	else:
		start_timer.stop()

# Starts the game
@rpc("any_peer", "call_local", "reliable")
func start_game() -> void:
	MultiplayerManager.sort_peer_players()
	get_tree().change_scene_to_packed(game_map_scene)
