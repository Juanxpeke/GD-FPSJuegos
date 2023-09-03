extends Unit
class_name King

# Private

# extremely unefficient code
func _update_movement_cells():
	super._update_movement_cells()
	var final_movement_cells = []
	for cell in movement_cells:
		var safe = true
		for unit in get_parent().enemy_player.get_children():
			for enemy_attacking_cell in unit.get_movement_cells():
				if cell == enemy_attacking_cell:
					safe = false
					break
			if !safe:
				break
		if safe:
			final_movement_cells.append(cell)
	movement_cells = final_movement_cells
	
# Public
	
# patch to avoid infinite recursion
func get_movement_cells():
	super._update_movement_cells()
	return movement_cells
