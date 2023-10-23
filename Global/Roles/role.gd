class_name Role
extends Resource

@export var name: String
@export var description: String
@export var icon: Texture2D # Lobby icon
@export var portrait: Texture2D  # Lobby portrait
@export var initial_health: int
@export var initial_money: int
@export var initial_units_names: Array[String]
@export var initial_units_offsets: Array[Vector2i]
@export var units_texture_atlas: Texture2D

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	assert(initial_units_names.size() == initial_units_offsets.size(), "role array lengths not matching")
	assert("king" in initial_units_names, "role has not king between its units")
