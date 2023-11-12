extends CanvasLayer

@export var main_menu_scene: PackedScene

@onready var win_icon := %WinIcon
@onready var win_label := %WinLabel
@onready var go_main_menu_button := %GoMainMenuButton

# Private

# Called when the node enters the scene tree for the first time.
func _ready():
	var win_role = RolesManager.get_role(GameManager.last_winner.role_id)
	win_icon.texture = win_role.icon 
	win_label.text = "%s WINS!" % GameManager.last_winner.name.to_upper()
	
	go_main_menu_button.pressed.connect(_go_main_menu_button_pressed)

# Called when the menu button is pressed
func _go_main_menu_button_pressed():
	multiplayer.multiplayer_peer.close()
	get_tree().change_scene_to_packed(main_menu_scene)
