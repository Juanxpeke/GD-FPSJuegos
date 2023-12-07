class_name TutorialButton
extends Button

@export var tutorial_image: Texture2D
@export_multiline var tutorial_description: String

# Private

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	tutorial_description = _parse_tutorial_description(tutorial_description)
	
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

# Parses the given tutorial description from Juanxpeke++ to BBCode
func _parse_tutorial_description(description: String) -> String:
	var parsed_description: String = ""

	while description.find("{url}") != -1:
		var url_start_index = description.find("{url}")
		var url_end_index = description.find("}", url_start_index + 5) 

		if url_end_index == -1:
			break
			
		var url_data = description.substr(url_start_index + 6, url_end_index - url_start_index - 6)

		var url_parts = url_data.split(",")

		if url_parts.size() != 2:
			break
			
		var url = url_parts[0].strip_edges()
		var label = url_parts[1].strip_edges()

		parsed_description += description.substr(0, url_start_index)
		parsed_description += "[color=#FFC509][url=\"" + url + "\"]" + label + "[/url][/color]"

		description = description.substr(url_end_index + 1)

	parsed_description += description
	return parsed_description
