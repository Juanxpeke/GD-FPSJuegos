class_name LifeBar
extends PanelContainer

var player: Player

@onready var life_progress_bar := %LifeProgressBar
@onready var life_label := %LifeLabel

# Private

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Updates the layout
func _update_layout() -> void:
	life_progress_bar.value = player.current_health
	life_label.text = str(player.current_health) + "/"  + str(player.role.initial_health)

# Public

# Sets the player
func set_player(player: Player) -> void:
	self.player = player
	life_progress_bar.max_value = player.role.initial_health
	player.health_changed.connect(_update_layout)
	_update_layout()
