class_name TutorialButton
extends Button

@export var tutorial_image: Texture2D
@export_multiline var tutorial_description: String

# Private

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	pressed.connect(_on_pressed)

# Called when the mouse enters the button
func _on_mouse_entered() -> void:
	scale *= 1
	
# Called when the mouse exits the button
func _on_mouse_exited() -> void:
	scale /= 1

# Called when the button is pressed
func _on_pressed() -> void:
	_tutorial().set_tutorial(self)

# Returns the tutorial root node
func _tutorial() -> Control:
	return get_parent().get_parent().get_parent().get_parent().get_parent().get_parent()  
