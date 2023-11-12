class_name LobbyRole
extends PanelContainer

var role_id: int

@onready var lobby_role_button := %LobbyRoleButton

# Private

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	role_id = get_index() % RolesManager.roles.size()
	
	_update_layout()
	
	lobby_role_button.mouse_entered.connect(_on_mouse_entered)
	lobby_role_button.mouse_exited.connect(_on_mouse_exited)
	lobby_role_button.pressed.connect(_on_pressed)

# Called when the mouse enters
func _on_mouse_entered() -> void:
	get_parent().get_parent().role_details.show_role_display(role_id)

# Called when the mouse exits
func _on_mouse_exited() -> void:
	get_parent().get_parent().role_details.stop_role_display()

# Called on pressed
func _on_pressed() -> void:
	MultiplayerManager.set_current_peer_player_role(role_id)

# Updates the layout
func _update_layout() -> void:
	lobby_role_button.texture_normal = RolesManager.get_role(role_id).icon

# Public

# Sets the role
func set_role_id(role_id: int) -> void:
	self.role_id = role_id
	_update_layout()
