extends CanvasLayer

@export var main_menu_scene: PackedScene

@onready var credits_container = %CreditsContainer
@onready var go_main_menu_button = %Button

var credits = [
	{
		"section": "Pawns & Legends: Gambit's Destiny",
		"author": "FPSJ-uegos"
	},
	{
		"section": "Programming",
		"author": "Juan Flores\nSergio Gálvez\nFelipe Morales",
	},
	{
		"section": "Art: Pixel Chess",
		"author": "dani-maccari.itch.io"
	},
	{
		"section": "Sound Effects: Board & Pieces",
		"author": "freesound.org\nel_boss\nDWOBoyle"
	}
]

func _ready():
	go_main_menu_button.pressed.connect(_go_main_menu_button_pressed)
	for credit in credits:
		var section_label = _create_label(credit.section, 32)
		var author_label = _create_label(credit.author, 16)
		
		credits_container.add_child(section_label)
		credits_container.add_child(author_label)
		
func _create_label(text, text_size) -> Label:
	var label = Label.new()
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	label.text = text
	label.add_theme_font_size_override("font_size", text_size)
	return label
	
func _go_main_menu_button_pressed():
	get_tree().change_scene_to_packed(main_menu_scene)
