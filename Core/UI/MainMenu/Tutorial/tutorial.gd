class_name Tutorial
extends Control

@onready var tutorial_button_list := %TutorialButtonList
@onready var tutorial_image := %TutorialImage
@onready var tutorial_title := %TutorialTitle
@onready var tutorial_description := %TutorialDescription

# Private

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	pass # Replace with function body
	
# Public

# Sets the tutorial
func set_tutorial(tutorial_button: TutorialButton):
	set_tutorial_image(tutorial_button.tutorial_image)
	set_tutorial_title(tutorial_button.text)
	set_tutorial_description(tutorial_button.tutorial_description)
	
	for button in tutorial_button_list.get_children():
		if button == tutorial_button:
			button.disabled = true
		else:
			button.disabled = false

# Sets the tutorial by reference
func set_tutorial_by_ref(reference: String) -> void:
	var tutorial_button = tutorial_button_list.get_node(reference)
	set_tutorial(tutorial_button)

# Sets the tutorial image
func set_tutorial_image(image_texture: Texture2D) -> void:
	tutorial_image.texture = image_texture
	
# Sets the tutorial title
func set_tutorial_title(text: String) -> void:
	tutorial_title.text = text
	
# Sets the tutorial description -> void:
func set_tutorial_description(text: String) -> void:
	tutorial_description.text = "[fill]%s[/fill]" % text

