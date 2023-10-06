extends TextureButton

static var store_units_sprites: Dictionary = {
	"king": preload("res://assets/backgrounds/medieval/medieval_1.png")
}

var unit_name: String

@onready var unit_cost_label: Label = %UnitCostLabel

# Public

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(_on_pressed)

# Called when the store unit button is pressed
func _on_pressed() -> void:
	if GameManager.player.can_afford(0):
		_hide()
		GameManager.player.buy_unit(unit_name)
	else:
		pass

# Shows the current store unit
func _show() -> void:
	disabled = false
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	unit_cost_label.show()
	
# Hides the current store unit
func _hide() -> void:
	disabled = true
	mouse_default_cursor_shape = Control.CURSOR_ARROW
	unit_cost_label.hide()
		
# Public

# Sets all the store unit data to the correspondent unit name
func set_unit(unit_name: String):
	self.unit_name = unit_name
	unit_cost_label.text = str(GameManager.units_data["king"].cost)
	
	_show()
