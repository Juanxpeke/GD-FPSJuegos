class_name UnitData
extends Resource

@export var scene: PackedScene
@export var cost: int
@export var early_weight: int
@export var middle_weight: int
@export var late_weight: int
@export var store_sprite: Texture2D

var current_early_weight: int = early_weight
var current_middle_weight: int = middle_weight
var current_late_weight: int = late_weight

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
