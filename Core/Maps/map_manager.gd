extends Node

class MapDescriptor:
	var name : String
	var path : String
	var probability_weight : int = 1 # porsiacaso
	
	func _init(path: String, weight := 1) -> void:
		self.path = path
		name = ((path.split("/")[-1]).split(".")[0]).replace("_", " ")
		probability_weight = weight

# INGRESAR NUEVOS MAPAS ACÄ
const MAPS : Array = [
	["res://Core/Maps/Dummy/dummy_map.tscn", 50],
	["res://Core/Maps/shejo_map.tscn", 50],
]

var map_descriptors : Array = MAPS.map(func (map) : 
	return MapDescriptor.new(map[0]) if map.size() == 1 else MapDescriptor.new(map[0], map[1])
)

var total_weight : int = 0

func _init() -> void:
	for map in map_descriptors:
		total_weight += map.probability_weight


func select_map() -> String:
	var accum : int = 0
	var random_val = randi() % total_weight
	var i := 0
	while i < map_descriptors.size():
		accum += map_descriptors[i].probability_weight
		if accum >= random_val:
			break
		i+=1
	var selected_map_path : String = map_descriptors[i].path
	return selected_map_path
