extends Consumable
class_name BishopLevelUp

func _initialize_attributes() -> void:
	texture_path = "res://assets/skill icons/bishopup.png"
	description = "inmediatily level up all bishop units you posess"

func _activate_effect(player: Player):
	print("spell effect activated")
	for unit in (player.match_dead_units + player.match_live_units):
		if unit.get_unit_class() == "bishop":
			unit.change_level.rpc(unit.level + 1)
