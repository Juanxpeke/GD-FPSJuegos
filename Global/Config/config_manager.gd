extends Node

# Load the custom images for the mouse cursor
var pointer = load("res://Global/Config/pointer.png")
var grab = load("res://Global/Config/grab.png")
var grabbing = load("res://Global/Config/grabbing.png")

# Private

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	Input.set_custom_mouse_cursor(grab, Input.CURSOR_ARROW)
	Input.set_custom_mouse_cursor(pointer, Input.CURSOR_POINTING_HAND)
	Input.set_custom_mouse_cursor(grab, Input.CURSOR_DRAG)
	Input.set_custom_mouse_cursor(grabbing, Input.CURSOR_CROSS)

# Public

# Sets the cursor shape
func set_cursor_shape(shape: String) -> void:
	match shape:
		"default": Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		"pointer": Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
		"grab": Input.set_default_cursor_shape(Input.CURSOR_DRAG)
		"grabbing": Input.set_default_cursor_shape(Input.CURSOR_CROSS)
