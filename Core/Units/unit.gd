class_name Unit
extends Node2D

@export var cell_descriptors: Array[CellDescriptor]

var movement_cells: Array = []

@onready var sprite := %Sprite
@onready var area := %Area

# Private

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	GameManager.board.add_unit(self)
		
	area.connect("mouse_entered", _on_mouse_entered)
	area.connect("mouse_exited", _on_mouse_exited)
	GameManager.connect("game_changed", _on_game_changed)

# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(delta: float) -> void:
	pass

# Called when the mouse enters the unit
func _on_mouse_entered() -> void:
	update_movement_cells()
	GameManager.board.show_movement_cells(movement_cells)
	
# Called when the mouse exits the unit
func _on_mouse_exited() -> void:
	GameManager.board.hide_movement_cells()

# Called when the game changes
func _on_game_changed() -> void:
	movement_cells.clear()

# Public

# Returns the movement cells 
func update_movement_cells() -> void:
	if not movement_cells.is_empty():
		return
		
	var origin_cell := GameManager.board.get_cell(position)
	
	for cell_descriptor in cell_descriptors:
		var descriptor_cells = cell_descriptor.get_cells(origin_cell)
		movement_cells += GameManager.board.get_free_cells(
				descriptor_cells, origin_cell, cell_descriptor.is_blockable)
	
# Returns the attack cells
func get_attack_cells() -> Array:
	return []
