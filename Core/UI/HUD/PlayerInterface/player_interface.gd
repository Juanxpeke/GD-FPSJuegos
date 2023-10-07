class_name PlayerInterface
extends Control

@export var turn_indicator_color: Color

var player: Player

@onready var peer_name_label: Label = %PeerNameLabel
@onready var life_bar: TextureProgressBar = %LifeBar
@onready var life_label: Label = %LifeLabel

# Private

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called when the related player health changes
func _on_player_health_changed() -> void:
	_update_life_interface()
	
# Called when a match turn ends
func _on_turn_ended() -> void:
	_update_turn_indicator()

# Updates the life interface
func _update_life_interface() -> void:
	life_bar.value = player.current_health
	life_label.text = str(player.current_health) + " / "  + str(player.role.initial_health)

# Updates the turn indicator
func _update_turn_indicator() -> void:
	if GameManager.map.get_current_turn_player() == player:
		peer_name_label.add_theme_color_override("font_color", turn_indicator_color)
	else:
		peer_name_label.remove_theme_color_override("font_color")

# Public

# Sets the related player
func set_player(player: Player) -> void:
	self.player = player
	
	peer_name_label.text = player.peer_player.name
	
	_update_turn_indicator()
	
	GameManager.map.turn_ended.connect(_on_turn_ended)
	
	life_bar.max_value = player.role.initial_health
	_update_life_interface()

	player.health_changed.connect(_on_player_health_changed)
