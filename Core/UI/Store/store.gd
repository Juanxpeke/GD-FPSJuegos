extends Control

var unit_costs: Dictionary = {
	#"": ,
	"bishop": 1,
	"knight": 1,
}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func get_unit_cost(unit_type: String) -> int:
	return unit_costs[unit_type]
