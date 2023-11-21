extends Board

const ALT_HOLE_LAYER := 5
const TURNS_TO_SWITCH : int = 5 # should be a odd number

var unused_hole_layer : int = ALT_HOLE_LAYER

# Called when map is initialized
func _on_map_initialized() -> void:
	super._on_map_initialized()
	GameManager.map.turn_ended.connect(_switch_hole_layers)
	set_layer_modulate(unused_hole_layer, Color(1, 1, 1, 0.2))

func _switch_hole_layers() -> void:
	if (GameManager.map.turn % TURNS_TO_SWITCH):
		print("pass")
		return
	var tmp = unused_hole_layer
	unused_hole_layer = Layer.HOLE_LAYER
	set_layer_modulate(unused_hole_layer, Color(1, 1, 1, 0.2))
	Layer.HOLE_LAYER = tmp
	set_layer_modulate(Layer.HOLE_LAYER, Color(1, 1, 1, 1))
	
	# units fall into the abyss and die
	for cell in get_used_cells(Layer.HOLE_LAYER):
		for unit in units:
			var unit_cell := get_cell(unit.global_position)
				
			if unit_cell == cell: 
				unit.die()
