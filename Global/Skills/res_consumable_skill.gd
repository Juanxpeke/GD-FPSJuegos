class_name ResConsumableSkill
extends ResSkill

# Private

# Consumes the skill
func _consume(player: Player) -> void:
	pass

# Public

# Adds itself to the player
func add_to_player(player: Player) -> void:
	_consume(player)
