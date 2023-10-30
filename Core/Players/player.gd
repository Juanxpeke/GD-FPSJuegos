class_name Player
extends Node2D

signal health_changed()
signal money_changed()
signal skills_changed()

var peer_player: MultiplayerManager.PeerPlayer
var enemy_player: Player

var role: Role

var current_health: int
var current_money: int 

#### Match ####
var match_live_units: Array[Unit] = []
var match_dead_units: Array[Unit] = []

#### Skills ####
var activable_skills : Array[Active] = [] # skills that can be activated

var active_skills : Array[Skill] = [] # skills that are taking effect right now

var skill_pool : Array[Skill] # All aquirable skills by this player

# Private

# Called when the node enters the tree for the first time
func _ready() -> void:
	GameManager.map.match_ended.connect(_on_match_ended)
	skill_pool = [
		Ghost.new(), 
		DimensionalJump.new(),
		BishopLevelUp.new(),
		Skill.new(), #test claramente
	]

#### Match ####

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

#### Multiplayer ####

# Sets up the multiplayer data for the player node
func multiplayer_setup(peer_player: MultiplayerManager.PeerPlayer):
	self.peer_player = peer_player
	name = "Player" + str(peer_player.id)
	role = RolesManager.get_role(peer_player.role_id)
	
	# Set initial skill
	if role.initial_skill_script:
		var skill = role.initial_skill_script.new() # REVIEW: Pass skills to resource
		skill.add_to_player(self)
		skills_changed.emit()
	
	current_health = role.initial_health
	current_money = role.initial_money
	
	for i in range(role.initial_units_names.size()):
		add_unit(
			role.initial_units_names[i],
			GameManager.map.get_initial_king_position() + GameManager.board.get_cell_local_origin(role.initial_units_offsets[i])
		)
		
	set_multiplayer_authority(peer_player.id)

	if multiplayer.get_unique_id() == peer_player.id:
		GameManager.set_player(self)

#### Units ####

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

# Adds a unit to the player
func add_unit(unit_class: String, target_position: Vector2) -> void:
	var unit = GameManager.units_data[unit_class].scene.instantiate() # REVIEW: Preload, as cell_descriptors get added before GameManager

	add_child(unit)
	set_multiplayer_authority(peer_player.id) # Necessary for units added after setup

	unit.name = unit.unit_class + str(get_child_count()) + str(peer_player.id)
	
	if multiplayer.get_unique_id() == peer_player.id:
		unit.position = target_position
		unit.match_initial_position = target_position
	else:
		unit.position = GameManager.board.get_mirror_position(target_position)
		unit.match_initial_position = GameManager.board.get_mirror_position(target_position)

	match_live_units.append(unit)

# Handles the movement of one of its units
func handle_unit_movement(unit: Unit, target_cell: Vector2i) -> void:
	match GameManager.map.match_phase:
		GameManager.map.MatchPhase.PREPARATION:
			handle_unit_movement_preparation(unit, target_cell)
		GameManager.map.MatchPhase.BATTLE:
			handle_unit_movement_battle(unit, target_cell)
	
# Handles the movement of one of its units, in preparation
func handle_unit_movement_preparation(unit: Unit, target_cell: Vector2i) -> void:
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

# Handles the right click button on a unit
func handle_unit_right_click(unit: Unit) -> void:
	match GameManager.map.match_phase:
		GameManager.map.MatchPhase.PREPARATION:
			handle_unit_right_click_preparation(unit)
			
# Handles the right click button on a unit, in preparation
func handle_unit_right_click_preparation(unit: Unit) -> void:
	if unit.get_unit_class() == "king": return
	
	var unit_cost = GameManager.units_data[unit.get_unit_class()].cost
	add_coins(unit_cost)
	
	unit.dissapear_forever.rpc()
	ConfigManager.set_cursor_shape("default")

# Fuses two units
func fuse_units(unit: Unit, other_unit: Unit, target_cell: Vector2i) -> void:
	var max_level = max(unit.level, other_unit.level)
	
	unit.dissapear_forever.rpc()
	other_unit.change_level.rpc(max_level + 1)

#### Match ####

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

# Loses the match
func lose_match() -> void:
	MultiplayerManager.log_msg("lose match %s" % name)
	current_health -= GameManager.phase_damages[GameManager.get_phase()]
	health_changed.emit()
	
	if current_health < 1:
		GameManager.end_game()
	
	GameManager.map.end_match()

#### Skills #### 

# Returns the player active skills
func get_active_skills() -> Array:
	return active_skills
	
# Return array of "gettable" skills plus the corresponding index in skill_pool
func get_skill_pool() -> Array: #returns Array[(Skill, int)]
	var result : Array = [] 
	var aquired_skills : Array = activable_skills + active_skills
	for i in range(0, skill_pool.size()):
		var skill = skill_pool[i]
		if !(skill in aquired_skills):
			result.append([skill, i])
	return result

# When player obtains a new usable skill
@rpc("call_local", "reliable")
func add_skill(skill_id : int) -> void:
	var skill = skill_pool[skill_id]
	skill.add_to_player(self)
	skills_changed.emit()

@rpc("call_local", "reliable")
func activate_skill(skill_id: int) -> void:
	var skill = activable_skills[skill_id]
	if skill.activate():
		var active_index = active_skills.size()
		active_skills.append(skill)
		skill.set_index(active_index)
		GameManager.map.game_changed.emit()

func deactivate_skill(index : int) -> void:
	print(str(active_skills[index]) + " dettached")
	active_skills.remove_at(index)

#### Store ####

# Checks if the player can afford a piece
func can_afford(amount: int) -> bool:
	return current_money >= amount

# Adds a specified amount of coins to the player
func add_coins(amount: int) -> void:
	current_money += amount
	money_changed.emit()

# Subtracts a specified amount of coins from the player
func subtract_coins(amount: int) -> void:
	if current_money >= amount:
		current_money -= amount
		money_changed.emit()

# Buys a unit
func buy_unit(unit_class: String) -> void:
	var base_cells = GameManager.board.get_base_cells()
	for base_cell in base_cells:
		var live_unit = get_live_unit_by_cell(base_cell)
		if live_unit == null:
			var unit_position = GameManager.board.get_cell_center(base_cell)
			spawn_unit.rpc(unit_class, unit_position)
			subtract_coins(GameManager.units_data[unit_class].cost)
			break

# Spawns a unit
@rpc("call_local", "reliable")
func spawn_unit(unit_class: String, target_position: Vector2) -> void:
	add_unit(unit_class, target_position)

