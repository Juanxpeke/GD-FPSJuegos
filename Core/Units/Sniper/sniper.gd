class_name Sniper
extends Unit

@onready var turn_indicator := %TurnIndicator

# Private

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	super._ready()
	_update_turn_indicator()

# Called when the turn ends
func _on_turn_ended() -> void:
	super._on_turn_ended()
	_update_turn_indicator()

# Updates the turn indicator
func _update_turn_indicator() -> void:
	if is_multiplayer_authority():
		turn_indicator.texture.region.position.x = 16 * (GameManager.map.turn % 4)
	else:
		turn_indicator.texture.region.position.x = 16 * ((GameManager.map.turn + 2) % 4)
