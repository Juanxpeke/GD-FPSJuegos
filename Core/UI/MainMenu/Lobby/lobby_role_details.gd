class_name LobbyRoleDetails
extends PanelContainer

@onready var role_name := %RoleName
@onready var role_health := %RoleHealth
@onready var role_money := %RoleMoney
@onready var role_description := %RoleDescription
@onready var role_icon := %RoleIcon
@onready var role_pieces_container := %RolePiecesContainer

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	pass # Replace with function body

# Public

# Changes the display by the given role id
func change_role_display(role_id: int) -> void:
	var role = RolesManager.get_role(role_id)
	
	role_name.text = role.name
	role_health.text = str(role.initial_health)
	role_money.text = str(role.initial_money)
	role_description.text = role.description
	role_icon.texture = role.icon
	
	var role_units_classes = role.initial_units_names 
	
	for i in role_pieces_container.get_child_count():
		var role_piece = role_pieces_container.get_child(i)
		
		if i < role_units_classes.size():
			role_piece.texture = RolesManager.get_unit_texture(role_units_classes[i], role)
			role_piece.show()
		else:
			role_piece.hide()
	
