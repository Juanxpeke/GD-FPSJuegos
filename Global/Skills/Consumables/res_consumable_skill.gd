class_name ResConsumableSkill
extends ResSkill

@export var health_given: int = 0
@export var money_given: int = 0

# Private

# Consumes the skill
func _consume(player: Player) -> void:
	player.add_health(health_given)
	player.add_money(money_given)

# Public

# Adds itself to the player
func add_to_player(player: Player) -> void:
	_consume(player)
