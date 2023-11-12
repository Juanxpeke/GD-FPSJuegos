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
var activable_skills: Array[ResActive] = [] # Skills that can be activated

var skills: Array[ResSkill] = [] # Skills that are taking effect right now

# Private

# Called when the node enters the tree for the first time
func _ready() -> void:
	GameManager.map.match_ended.connect(_on_match_ended)

#### Match ####

# Reset the dead and live units lists
func _reset_units() -> void:
	var dead_units = get_dead_units()
	for dead_unit in dead_units:
		match_live_units.append(dead_unit)
	match_dead_units.clear()
	match_live_units = match_live_units.filter(func(unit): return not unit.is_temporal)
			

# Called when the match ends
func _on_match_ended() -> void:
	var phase_reward = GameManager.phase_rewards[GameManager.get_phase()]
	MultiplayerManager.log_msg("phase reward before skills is %d" % phase_reward)
	
	for skill in skills:
		phase_reward += skill.phase_reward_addition
		
	MultiplayerManager.log_msg("phase reward after skills is %d" % phase_reward)
	
	add_coins(phase_reward)
			
	_reset_units()
	

# Public

#### Multiplayer ####

# Sets up the multiplayer data for the player node
func multiplayer_setup(peer_player: MultiplayerManager.PeerPlayer):
	self.peer_player = peer_player
	name = "Player" + str(peer_player.id)
	role = RolesManager.get_role(peer_player.role_id)
		
	current_health = role.initial_health
	current_money = role.initial_money
	
	skills.append(role.initial_skill)
	
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

	unit.set_multiplayer_authority(peer_player.id) # Necessary for units added after setup
	add_child(unit)
	# REVIEW: set_multiplayer_authority(peer_player.id)

	unit.name = unit.unit_class + str(get_child_count()) + str(peer_player.id)
	
	if multiplayer.get_unique_id() == peer_player.id:
		unit.position = target_position
		unit.match_initial_position = target_position
	else:
		unit.position = GameManager.board.get_mirror_position(target_position)
		unit.match_initial_position = GameManager.board.get_mirror_position(target_position)

	match_live_units.append(unit)

# Spawns a unit, called on each peer
@rpc("call_local", "reliable")
func spawn_unit(unit_class: String, target_position: Vector2) -> void:
	add_unit(unit_class, target_position)

# Handles the movement of one of its units
func handle_unit_movement(unit: Unit, target_cell: Vector2i) -> void:
	match GameManager.map.match_phase:
		GameManager.map.MatchPhase.PREPARATION:
			handle_unit_movement_preparation(unit, target_cell)
		GameManager.map.MatchPhase.BATTLE:
			handle_unit_movement_battle(unit, target_cell)
		_:
			unit.reset_position()
	
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
	
	var remove_unit_sale_discount = false
	for skill in skills:
		remove_unit_sale_discount = remove_unit_sale_discount or skill.remove_unit_sale_discount
	
	unit_cost = unit_cost if remove_unit_sale_discount else (unit_cost / 2)
	add_coins(unit_cost)
	
	unit.dissapear_forever.rpc()
	ConfigManager.set_cursor_shape("default")

# Fuses two units
func fuse_units(unit: Unit, other_unit: Unit, target_cell: Vector2i) -> void:
	var max_level = max(unit.level, other_unit.level)
	
	if max_level >= Unit.MAX_LEVEL:
		unit.reset_position()
		# TODO: Show HUD message
		return
	
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
	
	var phase_damage = GameManager.phase_damages[GameManager.get_phase()]
	for enemy_skill in enemy_player.skills:
		phase_damage += enemy_skill.phase_damage_addition
	
	current_health -= phase_damage
	health_changed.emit()
	
	if current_health < 1:
		GameManager.end_game(enemy_player.peer_player)
	
	GameManager.map.end_match()
	
#### Store ####

# Returns true if the player can afford the given amount of coins
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

# Buys the given unit
func buy_unit(unit_class: String) -> void:
	var base_cells = GameManager.board.get_base_cells()
	
	for base_cell in base_cells:
		var live_unit = get_live_unit_by_cell(base_cell)
		
		if live_unit == null:
			var unit_position = GameManager.board.get_cell_center(base_cell)
			spawn_unit.rpc(unit_class, unit_position)
			subtract_coins(GameManager.units_data[unit_class].cost)
			return

#### Skills #### 

# Returns the player skills
func get_skills() -> Array:
	return skills
	
# Return array of "gettable" skills ids
func get_skill_id_pool() -> Array[int]: 
	var skill_id_pool: Array[int] = []

	for i in range(SkillsManager.skills.size()):
		var skill = SkillsManager.get_skill(i)
		if not skill in skills:
			skill_id_pool.append(i)
			
	return skill_id_pool

# Adds a skill to the player, called on each peer
@rpc("call_local", "reliable")
func add_skill(skill_id: int) -> void:
	MultiplayerManager.log_msg("add skill %d to %s" % [skill_id, name])
	var skill = SkillsManager.get_skill(skill_id)
	MultiplayerManager.log_msg(skill)
	skill.add_to_player(self)
	skills_changed.emit()

# REVIEW

@rpc("call_local", "reliable")
func activate_skill(skill_id: int) -> void:
	var skill = activable_skills[skill_id]
	MultiplayerManager.log_msg(str(skill.active))
	if skill.activate():
		var active_index = skills.size()
		skills.append(skill)
		skill.set_index(active_index)
		GameManager.map.game_changed.emit()

func deactivate_skill(index : int) -> void:
	print(str(skills[index]) + " dettached")
	skills.remove_at(index)

# CLOSE REVIEW

