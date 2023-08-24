class_name Unit
extends Node2D

# Range -1 implies infinite range, that in practice is board size. If there exists
# board size changes we must implement a signal logic for infinite range units
@export var movement_range: int = -1 
@export var attack_range: int = -1
@export var can_jump: bool = false

var inner_movement_range: int
var inner_attack_range: int

@onready var sprite := %Sprite
@onready var area := %Area

# Private

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	inner_movement_range = movement_range
	if inner_movement_range == -1:
		inner_movement_range = GameManager.board.get_max_cell_range()
	
	inner_attack_range = attack_range
	if inner_attack_range == -1:
		inner_attack_range = GameManager.board.get_max_cell_range()
		
	area.connect("mouse_entered", _on_mouse_entered)
	area.connect("mouse_exited", _on_mouse_exited)

# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(delta: float) -> void:
	pass

# Called when the mouse enters the unit
func _on_mouse_entered() -> void:
	var origin_cell := GameManager.board.get_cell(position)
	var movement_cells := get_movement_cells()
	var filtered_cells := GameManager.board.filter_cells(movement_cells, origin_cell, !can_jump)
	GameManager.board.show_movement_cells(filtered_cells[0], filtered_cells[1])
	
# Called when the mouse exits the unit
func _on_mouse_exited() -> void:
	GameManager.board.hide_movement_cells()

# Public

# Returns the movement cells 
func get_movement_cells() -> Array:
	var movement_cells := []
	var origin_cell := GameManager.board.get_cell(position)
	
	# TODO add cell descriptors so you can dinamically add linear or diagonal or any
	# special kind of movement, and also block it (for just adding cell descriptors is not
	# necessary, just a private variable local_movement_cells = [...] that you can modify)
	for i in range(inner_movement_range):
		movement_cells.append(origin_cell + Vector2i(0, i))
	
	return movement_cells
	
# Returns the attack cells
func get_attack_cells() -> Array:
	return []
