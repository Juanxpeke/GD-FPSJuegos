class_name Player
extends Node2D


var enemy_player: Player

var role: RolesManager.Role

var current_health: int
var current_money: int 

var units_initial_positions: Array[Vector2] = []

### Skills ####
var activable_skills : Array[Skill] = []
var active_skills : Array[Skill] = []

# Private

func _activate_skill(index : int) -> void:
	if activable_skills[index].activate():
		active_skills.append(activable_skills[index])

# Public

# Sets up the multiplayer data for the player node
func multiplayer_setup(peer_player: MultiplayerManager.PeerPlayer):
	name = "Player" + str(peer_player.id)
	role = GameManager.get_role(peer_player.role)
	
	current_health = role.initial_health
	current_money = role.initial_money
	
	for i in range(role.initial_units_names.size()):
		var unit = GameManager.units_scenes[role.initial_units_names[i]].instantiate() # REVIEW: Preload, as cell_descriptors get added before GameManager
		var unit_position = GameManager.map.get_initial_king_position() + GameManager.board.get_cell_local_origin(role.initial_units_offsets[i])
		
		add_child(unit)
		
		unit.name = unit.unit_name + str(i) + str(peer_player.id)
		unit.sprite.modulate = role.color
		
		if multiplayer.get_unique_id() == peer_player.id:
			unit.position = unit_position
		else:
			unit.position = GameManager.board.get_mirror_position(unit_position)
		
	set_multiplayer_authority(peer_player.id) # REVIEW: Unit's cell_descriptors aren't updating as board was set before

# Gets units
func get_units() -> Array:
	return get_children()
	
# Gets a unit by the given index
func get_unit(index: int) -> Unit:
	return get_units()[index]
	
# Gets a unit by the given cell
func get_unit_by_cell(cell: Vector2i) -> Unit:
	var units = get_units()
	for unit in units:
		if GameManager.board.get_cell(unit.position) == cell:
			return unit
	return null

# Get all the players units cells
func get_all_units_cells() -> Array[Vector2i]:
	var units_cells = []
	var units = get_units()
	
	for unit in units:
		units_cells += unit.get_movement_cells()
	
	return units_cells

# Tries to kill the unit in the given cell
func receive_attack_in_cell(cell: Vector2i) -> void:
	var units = get_units()
	for unit in units:
		if GameManager.board.get_cell(unit.position) == cell:
			unit.die()
			return

# Handles the movement of one of its units
func handle_unit_movement(unit: Unit, target_cell: Vector2i) -> void:
	# Is not a valid movement cell, or its not player's turn
	if not (target_cell in unit.get_movement_cells()) or self != GameManager.map.get_current_turn_player():
		unit.reset_position()
		return
		
	for other_unit in get_units():
		if unit != other_unit and target_cell == other_unit.get_current_cell():
			if unit.get_unit_class() == other_unit.get_unit_class():
				# TODO: Config stuff
				fuse_units.rpc(unit.get_index(), other_unit.get_index(), target_cell)
				return
			else:
				unit.reset_position()
				return
			
	unit.change_position.rpc(GameManager.board.get_cell_center(target_cell))

# Returns the player active skills
func get_active_skills() -> Array:
	return active_skills

# Fuse two units
@rpc("call_local", "reliable")
func fuse_units(first_unit_index: int, second_unit_index: int, target_cell: Vector2i) -> void:
	var first_unit = get_child(first_unit_index)
	var second_unit = get_child(second_unit_index)
	
	print("fuse units: ", first_unit.name, "\t", second_unit.name)
	
	call_deferred("remove_child", first_unit)
	call_deferred("remove_child", second_unit)
	
	# TODO: Fusion stuff
	
	GameManager.map.advance_turn()
	GameManager.game_changed.emit()
