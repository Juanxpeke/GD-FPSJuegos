class_name Unit
extends Node2D

signal has_dead
signal has_revived

const MAX_LEVEL: int = 4

static var level_2_material: ShaderMaterial = load("res://Core/Units/level_2_material.tres")
static var level_3_material: ShaderMaterial = load("res://Core/Units/level_3_material.tres")
static var level_4_material: ShaderMaterial = load("res://Core/Units/level_4_material.tres")

@export var unit_class: String

@export var level_1_descriptors: Array[CellDescriptor]
@export var level_2_descriptors: Array[CellDescriptor]
@export var level_3_descriptors: Array[CellDescriptor]

# Match initial position
var match_initial_position: Vector2
# Is dead in the current match
var is_dead: bool = false
# Unit level
var level: int = 1
var level_cell_descriptors: Array[CellDescriptor]
var current_cell_descriptors: Array[CellDescriptor]
# Cached cells the unit can move in current game state
var movement_cells: Array = []
# When checked as temporal units will be discarded at the start of next match
var is_temporal : bool = false:
	set(v):
		if v:
			sprite.set_material(load("res://Core/Units/temporal_material.tres"))
		is_temporal = v

# Grab logic
static var is_grabbing: bool = false
var grabbed: bool = false
var grab_cell: Vector2

@onready var sprite := %Sprite
@onready var area := %Area

# Private

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	GameManager.board.add_unit(self)
	
	_update_role_data()
	_update_level_data()
	
	GameManager.map.preparation_ended.connect(_on_preparation_ended)
	GameManager.map.turn_ended.connect(_on_turn_ended)
	GameManager.map.skill_activated.connect(_on_turn_ended)
	GameManager.map.match_ended.connect(_on_match_ended)
	area.mouse_entered.connect(_on_mouse_entered)
	area.mouse_exited.connect(_on_mouse_exited)
	area.input_event.connect(_on_input_event)

# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(_delta: float) -> void:
	if grabbed:
		global_position = get_global_mouse_position()

# Called when the mouse enters the unit
func _on_mouse_entered() -> void:
	if is_grabbing: return
	
	ConfigManager.set_cursor_shape("grab")
	
	if GameManager.map.match_phase != GameManager.map.MatchPhase.BATTLE: return
	
	_update_movement_cells()
	GameManager.board.show_movement_cells(movement_cells)
	
# Called when the mouse exits the unit
func _on_mouse_exited() -> void:
	if is_grabbing: return
	
	ConfigManager.set_cursor_shape("default")
	
	GameManager.board.hide_movement_cells()
	
# Called when an input event occurs inside the unit
func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if not is_multiplayer_authority():
		return
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_left_button_pressed = event.pressed
		# Mouse left button pressed
		if mouse_left_button_pressed:
			if GameManager.map.match_phase == GameManager.map.MatchPhase.BATTLE:
				_update_movement_cells()
				GameManager.board.show_movement_cells(movement_cells)
			grab_cell = get_current_cell()
			grabbed = true
			is_grabbing = true # Caution: This has to be called by one unit
			ConfigManager.set_cursor_shape("grabbing")
		# Mouse left button unpressed and this unit was grabbed
		elif not mouse_left_button_pressed and grabbed:
			var target_cell = get_current_cell()
			
			# Request move to the player
			get_player().handle_unit_movement(self, target_cell)

			grabbed = false
			is_grabbing = false # Caution: This has to be called by one unit
			ConfigManager.set_cursor_shape("grab")
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		get_player().handle_unit_right_click(self)

# Called when the preparation ends
func _on_preparation_ended() -> void:
	pass

# Called when the turn ends
func _on_turn_ended() -> void:
	movement_cells.clear()
	
# Called when the match ends
func _on_match_ended() -> void:
	movement_cells.clear()
	if is_dead:
		revive()
	global_position = match_initial_position
	
# Updates the unit data by its player role
func _update_role_data() -> void:
	sprite.texture = RolesManager.get_unit_texture(get_unit_class(), get_player().role)
	
# Updates the unit data by its level
func _update_level_data() -> void:
	match level:
		1: 
			level_cell_descriptors = level_1_descriptors
		2:
			level_cell_descriptors = level_2_descriptors
			sprite.set_material(level_2_material)
		3:
			level_cell_descriptors = level_3_descriptors
			sprite.set_material(level_3_material)
		4:
			# TODO: level_4_descriptors
			sprite.set_material(level_4_material)
		
# Updates the unit movement cells 
func _update_movement_cells() -> void:
	
	if not movement_cells.is_empty():
		return

	var origin_cell := get_current_cell()
	
	# new array needs to contain copies of cell_descriptors
	current_cell_descriptors = []
	for cell_descriptor in level_cell_descriptors:
		var copy = cell_descriptor.duplicate(false) # duplicate dont copy non-exported variables
		copy.direction_index = cell_descriptor.direction_index
		current_cell_descriptors.append(copy)
		
	for skill in get_player().get_skills():
		skill.modify_current_cell_descriptor(self)
	
	for cell_descriptor in current_cell_descriptors:
		var descriptor_cells = cell_descriptor.get_cells(origin_cell)
		movement_cells += GameManager.board.get_free_cells(
				cell_descriptor, origin_cell, not is_multiplayer_authority())


# Public

# Gets the unit class
func get_unit_class() -> String:
	return unit_class.to_lower()

# Gets the unit player
func get_player() -> Player:
	return get_parent()

# Gets the unit current cell
func get_current_cell() -> Vector2i:
	return GameManager.board.get_cell(global_position)

# Gets the unit grab cell
func get_grab_cell() -> Vector2i:
	return grab_cell

# Gets the unit movement cells
func get_movement_cells() -> Array:
	_update_movement_cells()
	return movement_cells

# Resets the unit position
func reset_position() -> void:
	MultiplayerManager.log_msg("reset unit position %s" % name)
	global_position = GameManager.board.get_cell_center(grab_cell)

# Dies
func die() -> void:
	MultiplayerManager.log_msg("die %s" % name)
	is_dead = true
	sprite.hide()
	area.monitoring = false
	area.input_pickable = false
	has_dead.emit()

func be_captured_by(enemy_unit: Unit) -> void:
	die()
	get_player().match_live_units.erase(self)
	get_player().match_dead_units.append(self)

# Revives
func revive() -> void:
	MultiplayerManager.log_msg("revive %s" % name)
	is_dead = false
	sprite.show()
	area.monitoring = true
	area.input_pickable = true
	has_revived.emit()
	
# Dissapears forever on each peer, including current
@rpc("call_local", "reliable")
func dissapear_forever() -> void:
	MultiplayerManager.log_msg("dissapear forever %s" % name)
	get_player().match_live_units.erase(self) # REVIEW: Possible bug, when erasing element in for
	queue_free()
	
# Changes the unit level on each peer, including current, it has to have the any_peer
# tag so it can be called by the spells, that have not authority set
@rpc("any_peer", "call_local", "reliable")
func change_level(target_level: int) -> void:
	if target_level > MAX_LEVEL: return
	
	MultiplayerManager.log_msg("change unit level %s" % name)
	
	level = target_level
	_update_level_data()
	
	if GameManager.map.match_phase == GameManager.map.MatchPhase.BATTLE:
		GameManager.map.end_turn(get_player())

# Changes the unit position on each peer, including current
@rpc("call_local", "reliable")
func change_position(target_position: Vector2) -> void:
	MultiplayerManager.log_msg("change unit position %s" % name)
	
	var final_position = target_position
	
	if not is_multiplayer_authority():
		final_position = GameManager.board.get_mirror_position(target_position)
		
	global_position = final_position
	
	match GameManager.map.match_phase:
		GameManager.map.MatchPhase.PREPARATION:
			match_initial_position = final_position
		GameManager.map.MatchPhase.BATTLE:
			var final_cell = GameManager.board.get_cell(final_position)
			
			get_player().enemy_player.receive_attack_in_cell(final_cell, self)
			
			GameManager.map.end_turn(get_player())
			
	GameManager.play_sound("unit_move")

