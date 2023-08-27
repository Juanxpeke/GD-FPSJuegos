extends Node

signal board_initialized
signal board_destroyed
signal game_changed # Called on ANY game change

var board: Board

# Private

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(delta: float) -> void:
	pass

# Public

# Sets the cursor shape
func set_cursor_shape(shape: String) -> void:
	match shape:
		"default": Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		"pointer": Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
		"grab": Input.set_default_cursor_shape(Input.CURSOR_DRAG)
		"grabbing": Input.set_default_cursor_shape(Input.CURSOR_CROSS)

# Called to set the board
func set_board(board: Board) -> void:
	self.board = board
	board_initialized.emit()
