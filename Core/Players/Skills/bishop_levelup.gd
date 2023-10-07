extends Consumable
class_name BishopLevelUp

func _init() -> void:
	texture_path = "res://assets/skill icons/bishopup.png"
	description = "inmediatily level up all bishop units you posess"

func _activate_effect(player: Player):
	print("efectoactivado")
	for unit in (player.match_dead_units + player.match_live_units):
		print(unit.unit_name)
		if unit.unit_name == "Bishop":
			unit.level_up()
