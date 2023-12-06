class_name UnitData
extends Resource

@export var scene: PackedScene
@export_multiline var description: String
@export var cost: int
@export var weights: Dictionary = {
	"early": 0,
	"middle": 0,
	"late": 0,
}

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	pass # Replace with function body
