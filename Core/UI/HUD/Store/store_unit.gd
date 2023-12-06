class_name StoreUnit
extends PanelContainer

@export var disabled_texture: Texture2D

var unit_class: String

@onready var store_unit_button := %StoreUnitButton
@onready var store_unit_sprite := %StoreUnitSprite
@onready var store_unit_cost_label := %StoreUnitCostLabel

# Public

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	store_unit_button.mouse_entered.connect(_on_mouse_entered)
	store_unit_button.mouse_exited.connect(_on_mouse_exited)
	store_unit_button.pressed.connect(_on_pressed)

# Called when the mouse enters the unit button
func _on_mouse_entered() -> void:
	if store_unit_button.disabled: return
	
	var temporal_unit = GameManager.units_data[unit_class].scene.instantiate()
	
	GameManager.map.hud.show_unit_details(temporal_unit)

# Called when the mouse exits the unit button
func _on_mouse_exited() -> void:
	GameManager.map.hud.hide_unit_details()

# Called when the store unit button is pressed
func _on_pressed() -> void:
	if not GameManager.player.can_afford(GameManager.units_data[unit_class].cost):
		return
	
	var unit_cell = GameManager.player.get_free_base_cell()
	
	if unit_cell == null:
		return
	
	GameManager.player.buy_unit(unit_class, unit_cell)
	_hide()

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
	store_unit_sprite.texture = disabled_texture
	GameManager.map.hud.hide_unit_details()

# Public

# Sets all the store unit data to the correspondent unit name
func set_unit(unit_class: String):
	self.unit_class = unit_class
	store_unit_sprite.texture = RolesManager.get_unit_texture(unit_class, GameManager.player.role)
	store_unit_cost_label.text = str(GameManager.units_data[unit_class].cost)
	
	_show()
