class_name UnitLevelUp
extends ResConsumableSkill

@export var leveled_up_units: Array[String]

# Private

# Consumes the skill
func _consume(player: Player) -> void:
	for unit in (player.match_dead_units + player.match_live_units):
		if unit.get_unit_class() in leveled_up_units:
			unit.change_level.rpc(unit.level + 1)
