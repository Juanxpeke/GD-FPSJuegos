class_name StoreUnit
extends PanelContainer

var unit_class: String

@onready var store_unit_button := %StoreUnitButton
@onready var store_unit_cost_label := %StoreUnitCostLabel

# Public

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	store_unit_button.pressed.connect(_on_pressed)

# Called when the store unit button is pressed
func _on_pressed() -> void:
	if GameManager.player.can_afford(GameManager.units_data[unit_class].cost):
		_hide()
		GameManager.player.buy_unit(unit_class)
	else:
		pass

# Shows the current store unit
func _show() -> void:
	store_unit_button.disabled = false
	store_unit_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	store_unit_cost_label.show()
	
# Hides the current store unit
func _hide() -> void:
	store_unit_button.disabled = true
	store_unit_button.mouse_default_cursor_shape = Control.CURSOR_ARROW
	store_unit_cost_label.hide()
		
# Public

# Sets all the store unit data to the correspondent unit name
func set_unit(unit_class: String):
	self.unit_class = unit_class
	store_unit_button.texture_normal = GameManager.units_data[unit_class].store_sprite
	store_unit_cost_label.text = str(GameManager.units_data[unit_class].cost)
	
	_show()
