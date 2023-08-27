class_name Unit
extends Node2D

@export var cell_descriptors: Array[CellDescriptor]

var movement_cells: Array = []
# Grab logic
static var is_grabbing: bool = false # TODO: Maintain this logic with multiplayer
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

# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(_delta: float) -> void:
	if grabbed:
		position = get_global_mouse_position()

# Called when the mouse enters the unit
func _on_mouse_entered() -> void:
	if is_grabbing: return
	update_movement_cells()
	GameManager.board.show_movement_cells(movement_cells)
	GameManager.set_cursor_shape("grab")
	
# Called when the mouse exits the unit
func _on_mouse_exited() -> void:
	if is_grabbing: return
	GameManager.board.hide_movement_cells()
	GameManager.set_cursor_shape("default")
	
# Called when an input event occurs
func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			grab_cell = GameManager.board.get_cell(position)
			grabbed = true
			is_grabbing = true # Caution: This has to be called by one unit
			GameManager.set_cursor_shape("grabbing")
		elif grabbed:
			var origin_cell = GameManager.board.get_cell(position)
			
			if origin_cell in movement_cells:
				position = GameManager.board.get_cell_center(origin_cell)
				GameManager.game_changed.emit()
				GameManager.board.hide_movement_cells() # Caution: Very ugly logic, but needs multiplayer stuff to improve
				update_movement_cells()
				GameManager.board.show_movement_cells(movement_cells)
			else:
				position = GameManager.board.get_cell_center(grab_cell)

			
			grabbed = false
			is_grabbing = false # Caution: This has to be called by one unit
			GameManager.set_cursor_shape("grab")

# Called when the game changes
func _on_game_changed() -> void:
	movement_cells.clear()

# Public

# Tries to update the movement cells 
func update_movement_cells() -> void:
	if not movement_cells.is_empty():
		return
		
	var origin_cell := GameManager.board.get_cell(position)
	
	for cell_descriptor in cell_descriptors:
		var descriptor_cells = cell_descriptor.get_cells(origin_cell)
		movement_cells += GameManager.board.get_free_cells(
				descriptor_cells, origin_cell, cell_descriptor.is_blockable)
