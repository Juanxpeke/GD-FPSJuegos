class_name PlayerInterface
extends Control

var player: Player

@onready var life_bar: TextureProgressBar = %LifeBar
@onready var life_label: Label = %LifeLabel

# Private

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called when the related player health changes
func _on_player_health_changed() -> void:
	_update_life_interface()

# Updates the life interface
func _update_life_interface() -> void:
	life_bar.value = player.current_health
	life_label.text = str(player.current_health) + " / "  + str(player.role.initial_health)

# Public

# Sets the related player
func set_player(player: Player) -> void:
	self.player = player
	
	life_bar.max_value = player.role.initial_health
	_update_life_interface()

	player.health_changed.connect(_on_player_health_changed)
