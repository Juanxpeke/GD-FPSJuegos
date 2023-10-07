class_name UnitData
extends Resource

@export var scene: PackedScene
@export var cost: int
@export var weights: Dictionary = {
	"early": 0,
	"middle": 0,
	"late": 0,
}
@export var store_sprite: Texture2D

var current_weights: Dictionary = weights

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
