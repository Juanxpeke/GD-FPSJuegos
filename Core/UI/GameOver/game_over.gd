extends CanvasLayer

@export var main_menu_scene: PackedScene

@onready var win_label := %WinLabel
@onready var button := %Button

# Private

# Called when the node enters the scene tree for the first time.
func _ready():
	win_label.text = "%s WINS!" % GameManager.last_winner.name.to_upper()
	
	button.pressed.connect(_button_pressed)

# Called when the menu button is pressed
func _button_pressed():
	multiplayer.multiplayer_peer.close()
	get_tree().change_scene_to_packed(main_menu_scene)
