class_name Sniper
extends Unit

@onready var turn_indicator := %TurnIndicator

# Private
var _direction_index = 0

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	super._ready()
	GameManager.map.preparation_ended.connect(_update_turn_indicator)
	GameManager.map.player_turn_ended.connect(_on_player_turn_ended)
	_update_turn_indicator()

# Called when the turn ends
func _on_player_turn_ended(player: Player) -> void:
	if player != get_player():
		return
	_direction_index += 1
	_update_turn_indicator()

# Updates the turn indicator
func _update_turn_indicator() -> void:
	if is_multiplayer_authority():
		turn_indicator.texture.region.position.x = 16 * (_direction_index % 4)
	else:
		turn_indicator.texture.region.position.x = 16 * ((_direction_index + 2) % 4)
