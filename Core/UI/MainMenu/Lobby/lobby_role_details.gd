class_name LobbyRoleDetails
extends PanelContainer

var show_count: int = 0

var skill_description_scroll_bar: VScrollBar
var skill_description_scroll_prev_value: float
var skill_description_scroll_down: bool = true
var skill_description_is_scrolling: bool = false
var skill_description_stay_time: float = 3.0

@onready var role_name := %RoleName
@onready var role_health := %RoleHealth
@onready var role_money := %RoleMoney
@onready var role_description := %RoleDescription
@onready var role_icon := %RoleIcon
@onready var role_pieces_container := %RolePiecesContainer
@onready var role_skill_icon := %RoleSkillIcon
@onready var role_skill_description := %RoleSkillDescription

# Private

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	skill_description_scroll_bar = role_skill_description.get_v_scroll_bar()
	
# Called on each frame
func _process(delta: float) -> void:
	if MultiplayerManager.is_online() and skill_description_is_scrolling:
		if skill_description_scroll_down:
			skill_description_scroll_bar.value += 1
		else:
			skill_description_scroll_bar.value -= 1
		
		if skill_description_scroll_bar.value == skill_description_scroll_prev_value:
			skill_description_scroll_down = not skill_description_scroll_down
			_halt_and_scroll()
			
		skill_description_scroll_prev_value = skill_description_scroll_bar.value

# Halts and scrolls
func _halt_and_scroll() -> void:
	skill_description_is_scrolling = false
	
	var counter = show_count
	
	var timer = get_tree().create_timer(skill_description_stay_time)
	await timer.timeout
	
	if counter != show_count: return
	
	skill_description_is_scrolling = true

# Public

# Shows the display by the given role id
func show_role_display(role_id: int) -> void:
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
	
	role_skill_icon.texture = role.initial_skill.icon
			
	role_skill_description.text = "[fill][color=#e3b738]%s:[/color] %s[/fill]" \
		% [role.initial_skill.name, role.initial_skill.description]

	skill_description_scroll_bar.value = 0
	skill_description_scroll_prev_value = 0
	skill_description_scroll_down = true
	
	show()
	
	_halt_and_scroll()

# Stops the role display
func stop_role_display() -> void:
	show_count += 1
	skill_description_is_scrolling = false
	hide()
