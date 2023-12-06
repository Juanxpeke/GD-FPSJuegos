class_name DetailsInterface
extends PanelContainer

@onready var unit_class_label := %UnitClassLabel
@onready var unit_sprite := %UnitSprite
@onready var details_board := %DetailsBoard
@onready var unit_description_label := %UnitDescriptionLabel

# Private

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	hide_details()


#Public

# Sets the unit
func set_unit(unit: Unit) -> void:
	unit_class_label.text = unit.unit_class
	unit_description_label.text = GameManager.units_data[unit.get_unit_class()].description
	unit_sprite.texture = RolesManager.get_unit_texture(unit.get_unit_class(), GameManager.player.role)

# Shows the details
func show_details() -> void:
	show()

# Hides the details
func hide_details() -> void:
	hide()

