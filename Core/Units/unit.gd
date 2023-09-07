class_name Unit
extends Node2D

@export var unit_name: String

@export var level_1_descriptors: Array[CellDescriptor]
@export var level_2_descriptors: Array[CellDescriptor]
@export var level_3_descriptors: Array[CellDescriptor]

# Unit level
var level: int = 1
var level_cell_descriptors: Array[CellDescriptor]
# Cached cells the unit can move in current game state
var movement_cells: Array = []

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
		
	area.connect("mouse_entered", _on_mouse_entered)
	area.connect("mouse_exited", _on_mouse_exited)
	area.connect("input_event", _on_input_event)
	GameManager.connect("game_changed", _on_game_changed)
	
	_update_level_data()

# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(_delta: float) -> void:
	if grabbed:
		position = get_global_mouse_position()

# Called when the mouse enters the unit
func _on_mouse_entered() -> void:
	if is_grabbing: return
	_update_movement_cells()
	GameManager.board.show_movement_cells(movement_cells)
	ConfigManager.set_cursor_shape("grab")
	
# Called when the mouse exits the unit
func _on_mouse_exited() -> void:
	if is_grabbing: return
	GameManager.board.hide_movement_cells()
	ConfigManager.set_cursor_shape("default")
	
# Called when an input event occurs inside the unit
func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if not is_multiplayer_authority():
		return
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_left_button_pressed = event.pressed
		# Mouse left button pressed
		if mouse_left_button_pressed:
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

# Called when the game changes
func _on_game_changed() -> void:
	movement_cells.clear()
	
# Updates the unit data by its level
func _update_level_data() -> void:
	match level:
		1: level_cell_descriptors = level_1_descriptors
		2: level_cell_descriptors = level_2_descriptors
		3: level_cell_descriptors = level_3_descriptors
		
# Updates the movement cells 
func _update_movement_cells() -> void:
	if not movement_cells.is_empty():
		return
		
	var origin_cell := get_current_cell()
	
	for cell_descriptor in level_cell_descriptors:
		var descriptor_cells = cell_descriptor.get_cells(origin_cell)
		movement_cells += GameManager.board.get_free_cells(
				cell_descriptor, origin_cell)

# Public

# Gets the unit class
func get_unit_class() -> String:
	return unit_name

# Gets the unit player
func get_player() -> Player:
	return get_parent()

# Gets the unit current cell
func get_current_cell() -> Vector2i:
	return GameManager.board.get_cell(position)

# Gets the unit movement cells
func get_movement_cells() -> Array:
	_update_movement_cells()
	return movement_cells

# Resets the unit position
func reset_position() -> void:
	print("reset unit position: ", name)
	position = GameManager.board.get_cell_center(grab_cell)

# Dies
func die():
	print("die ", name)
	queue_free()

# Changes the unit position on each peer, including current
@rpc("call_local", "reliable")
func change_position(target_position: Vector2) -> void:
	print("change unit position: ", name)
	var final_position = target_position
	
	if not is_multiplayer_authority():
		final_position = GameManager.board.get_mirror_position(target_position)
		
	position = final_position
	
	var final_cell = GameManager.board.get_cell(final_position)
	
	get_player().enemy_player.receive_attack_in_cell(final_cell)
		
	GameManager.map.advance_turn()
	GameManager.game_changed.emit()
	
# Level ups the unit on each peer, including self
# CAUTION: This is intended to be called from the store
@rpc("call_local", "reliable")
func level_up() -> void:
	level += 1
	_update_level_data()
	GameManager.game_changed.emit()
