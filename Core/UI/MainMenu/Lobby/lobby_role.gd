class_name LobbyRole
extends TextureButton

var role_id: int

# Private

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	role_id = get_index() % RolesManager.roles.size()
	
	_update_layout()
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	pressed.connect(_on_pressed)

# Called when the mouse enters
func _on_mouse_entered() -> void:
	print("lobby role mouse entered, role id: ", role_id)
	get_parent().get_parent().role_details.change_role_display(role_id)
	get_parent().get_parent().role_details.show()

# Called when the mouse exits
func _on_mouse_exited() -> void:
	print("lobby role mouse exited, role id: ", role_id)
	get_parent().get_parent().role_details.hide()

# Called on pressed
func _on_pressed() -> void:
	MultiplayerManager.set_current_peer_player_role(role_id)

# Updates the layout
func _update_layout() -> void:
	texture_normal = RolesManager.get_role(role_id).icon

# Public

# Sets the role
func set_role_id(role_id: int) -> void:
	self.role_id = role_id
	_update_layout()
