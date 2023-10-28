extends TextureButton

var unit_class: String

@onready var unit_cost_label: Label = %UnitCostLabel

# Public

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(_on_pressed)

# Called when the store unit button is pressed
func _on_pressed() -> void:
	if GameManager.player.can_afford(GameManager.units_data[unit_class].cost):
		_hide()
		GameManager.player.buy_unit(unit_class)
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
func set_unit(unit_class: String):
	self.unit_class = unit_class
	texture_normal = GameManager.units_data[unit_class].store_sprite
	unit_cost_label.text = str(GameManager.units_data[unit_class].cost)
	
	_show()
