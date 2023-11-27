class_name PlayerInterface
extends Panel

@export var turn_indicator_color: Color

var player: Player

@onready var life_bar: LifeBar = $LifeBar
@onready var passive_skills_list: PassiveSkillsList = $PassiveSkillsList
@onready var active_skills_list: ActiveSkillsList = $ActiveSkillsList
@onready var role_icon: TextureRect = $TopContainer/RoleIcon
@onready var peer_name_label: Label = $TopContainer/PeerNameLabel

# Private

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	pass
	
# Called when a match turn ends
func _on_turn_ended() -> void:
	_update_turn_indicator()
	
# Called when a match ends
func _on_match_ended() -> void:
	_update_turn_indicator()

# Updates the turn indicator
func _update_turn_indicator() -> void:
	if GameManager.map.get_current_turn_player() == player:
		get_theme_stylebox('panel').border_color = Color(turn_indicator_color, 0.8)
		peer_name_label.add_theme_color_override("font_color", turn_indicator_color)
	else:
		get_theme_stylebox('panel').border_color = Color("#ebe5ba", 0.8)
		peer_name_label.remove_theme_color_override("font_color")

# Public

# Sets the related player
func set_player(player: Player) -> void:
	self.player = player
	
	role_icon.texture = player.role.icon
	peer_name_label.text = player.peer_player.name
	
	_update_turn_indicator()
	
	GameManager.map.turn_ended.connect(_on_turn_ended)
	GameManager.map.match_ended.connect(_on_match_ended)
	
	life_bar.set_player(player)
	passive_skills_list.set_player(player)
	active_skills_list.set_player(player)
