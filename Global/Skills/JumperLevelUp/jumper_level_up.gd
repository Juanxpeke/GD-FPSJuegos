class_name JumperLevelUp
extends ResConsumableSkill

# Private

# Consumes the skill
func _consume(player: Player) -> void:
	for unit in (player.match_dead_units + player.match_live_units):
		if unit.get_unit_class() == "jumper":
			unit.change_level.rpc(unit.level + 1)
