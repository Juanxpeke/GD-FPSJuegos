class_name UILobbyPlayer
extends MarginContainer

@onready var player_name: Label = %Name
@onready var player_role: Label = %Role
@onready var ready_texture: TextureRect = %Ready

var player_id: int


func _ready() -> void:
	player_role.hide()
	ready_texture.hide()


func setup(player: MultiplayerManager.PeerPlayer) -> void:
	player_id = player.id
	name = str(player_id)
	_update(player)
	MultiplayerManager.peer_player_updated.connect(_on_player_updated)


func _on_player_updated(id: int) -> void:
	if id == player_id:
		_update(MultiplayerManager.get_peer_player(player_id))


func _update(player: MultiplayerManager.PeerPlayer):
	_set_player_name(player.name)
	_set_player_role(player.role)


func _set_player_name(value: String) -> void:
	player_name.text = value


func _set_player_role(value: MultiplayerManager.Role) -> void:
	player_role.visible = value != MultiplayerManager.Role.NONE
	match value:
		MultiplayerManager.Role.ROLE_A:
			player_role.text = "Role A"
		MultiplayerManager.Role.ROLE_B:
			player_role.text = "Role B"


func set_ready(value: bool) -> void:
	ready_texture.visible = value
