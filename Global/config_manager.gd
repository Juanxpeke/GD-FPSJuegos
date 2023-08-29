extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Sets the cursor shape
func set_cursor_shape(shape: String) -> void:
	match shape:
		"default": Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		"pointer": Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
		"grab": Input.set_default_cursor_shape(Input.CURSOR_DRAG)
		"grabbing": Input.set_default_cursor_shape(Input.CURSOR_CROSS)
