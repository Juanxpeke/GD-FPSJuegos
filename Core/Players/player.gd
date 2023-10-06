class_name Player
extends Node2D

var enemy_player: Player

var role: RolesManager.Role

var current_health: int
var current_money: int 

var match_units_positions: Array[Vector2] = []
var match_live_units: Array[Unit] = []
var match_dead_units: Array[Unit] = []


### Skills ####
var activable_skills : Array[Active] = []

var active_skills : Array[Skill] = []

# Private

# Called when the node enters the tree for the first time
func _ready() -> void:
	GameManager.map.match_ended.connect(_on_match_ended)
	Ghost.new().add_to_player(self) # test #
	

# When player obtains a new usable skill
@rpc("call_local", "reliable")
func add_skill(skill : Skill) -> void:
	skill.add_to_player(self)
	print(activable_skills, active_skills)

# Activates the given skill
@rpc("call_local", "reliable")
func _activate_skill(index : int) -> void:
	var skill: Active = activable_skills[index]
	if skill.activate():
		var active_index = active_skills.size()
		active_skills.append(skill)
		skill.set_index(active_index)
		GameManager.map.game_changed.emit()
		

func deactivate_skill(index : int) -> void:
	print(str(active_skills[index]) + " dettached")
	active_skills.remove_at(index)

# Temp function to test active skills (TODO: Remove this)
func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventKey and event.pressed): return
	if not is_multiplayer_authority(): return
	if not GameManager.map.get_current_turn_player() == self: return
	
	match event.keycode:
		KEY_1:
			_activate_skill.rpc(0)
		

# Reset the dead and live units lists
func _reset_units() -> void:
	var dead_units = get_dead_units()
	for dead_unit in dead_units:
		match_live_units.append(dead_unit)
	match_dead_units.clear()

# Called when the match ends
func _on_match_ended() -> void:
	_reset_units()
	

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
			unit.match_initial_position = unit_position
		else:
			unit.position = GameManager.board.get_mirror_position(unit_position)
			unit.match_initial_position = GameManager.board.get_mirror_position(unit_position)
	
		match_live_units.append(unit)
		
	set_multiplayer_authority(peer_player.id) # REVIEW: Unit's cell_descriptors aren't updating as board was set before

	if multiplayer.get_unique_id() == peer_player.id:
		GameManager.set_player(self)

# Gets all the dead units
func get_dead_units() -> Array:
	return match_dead_units
	
# Gets a dead unit by the given index
func get_dead_unit(index: int) -> Unit:
	return match_dead_units[index]

# Gets all the live units
func get_live_units() -> Array:
	return match_live_units
	
# Gets a live unit by the given index
func get_live_unit(index: int) -> Unit:
	return match_live_units[index]
	
# Gets a live unit by the given cell
func get_live_unit_by_cell(cell: Vector2i) -> Unit:
	var live_units = get_live_units()
	for live_unit in live_units:
		if GameManager.board.get_cell(live_unit.position) == cell:
			return live_unit
	return null

# Tries to kill the unit in the given cell
func receive_attack_in_cell(cell: Vector2i) -> void:
	var target_unit = get_live_unit_by_cell(cell)
	
	if target_unit == null: return
	
	if target_unit.get_unit_class() == "king":
		lose_match()
	else:
		match_live_units.erase(target_unit)
		match_dead_units.append(target_unit)
		target_unit.die()

# Handles the movement of one of its units
func handle_unit_movement(unit: Unit, target_cell: Vector2i) -> void:
	match GameManager.map.match_phase:
		GameManager.map.MatchPhase.STORE:
			handle_unit_movement_store(unit, target_cell)
		GameManager.map.MatchPhase.BATTLE:
			handle_unit_movement_battle(unit, target_cell)
	
# Handles the movement of one of its units, in store
func handle_unit_movement_store(unit: Unit, target_cell: Vector2i) -> void:
	# Is not a valid base cell
	if not (target_cell in GameManager.board.get_base_cells()):
		unit.reset_position()
		return
		
	for other_unit in get_live_units():
		if unit != other_unit and target_cell == other_unit.get_current_cell():
			if unit.get_unit_class() == other_unit.get_unit_class():
				# TODO: Config stuff
				fuse_units(unit, other_unit, target_cell)
				return
			else:
				unit.reset_position()
				return
			
	unit.change_position.rpc(GameManager.board.get_cell_center(target_cell))
	
# Handles the movement of one of its units, in battle
func handle_unit_movement_battle(unit: Unit, target_cell: Vector2i) -> void:
	# Is not a valid movement cell, or its not player's turn
	if not (target_cell in unit.get_movement_cells()) or self != GameManager.map.get_current_turn_player():
		unit.reset_position()
		return
		
	for other_unit in get_live_units():
		if unit != other_unit and target_cell == other_unit.get_current_cell():
			if unit.get_unit_class() == other_unit.get_unit_class():
				# TODO: Config stuff
				fuse_units(unit, other_unit, target_cell)
				return
			else:
				unit.reset_position()
				return
			
	unit.change_position.rpc(GameManager.board.get_cell_center(target_cell))

# Fuses two units
func fuse_units(unit: Unit, other_unit: Unit, target_cell: Vector2i) -> void:
	match_live_units.erase(other_unit) # REVIEW: Possible bug, when erasing element in for
	unit.dissapear_forever.rpc()
	
	other_unit.level_up.rpc(GameManager.board.get_cell_center(target_cell))
	
# Returns the player active skills
func get_active_skills() -> Array:
	return active_skills

# Loses the match
func lose_match() -> void:
	print("lose match, ", name)
	GameManager.map.end_match()
