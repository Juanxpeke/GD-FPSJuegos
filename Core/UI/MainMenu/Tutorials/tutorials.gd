class_name Tutorials
extends Control

@onready var back_button := %BackButton
@onready var tutorials_buttons_list := %TutorialsButtonsList
@onready var tutorial_image := %TutorialImage
@onready var tutorial_title := %TutorialTitle
@onready var tutorial_description := %TutorialDescription

# Private

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	back_button.pressed.connect(_on_back_button_pressed)
	tutorial_description.meta_clicked.connect(_on_tutorial_url_clicked)
	set_tutorial(tutorials_buttons_list.get_child(0))
	
# Called when the back button is pressed
func _on_back_button_pressed() -> void:
	get_parent().get_parent().back_menu()
	
# Called when a tutorial URL is clicked
func _on_tutorial_url_clicked(meta: Variant) -> void:
	set_tutorial_by_ref(meta)


# Public

# Sets the tutorial
func set_tutorial(tutorial_button: TutorialButton):
	set_tutorial_image(tutorial_button.tutorial_image)
	set_tutorial_title(tutorial_button.text)
	set_tutorial_description(tutorial_button.tutorial_description)
	
	for button in tutorials_buttons_list.get_children():
		if button == tutorial_button:
			button.disabled = true
		else:
			button.disabled = false

# Sets the tutorial by reference
func set_tutorial_by_ref(reference: String) -> void:
	var tutorial_button = tutorials_buttons_list.get_node(reference)
	
	if tutorial_button is TutorialButton:
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

