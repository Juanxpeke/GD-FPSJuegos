class_name Swordman
extends Unit

# Private
var _basic_descriptor = load("res://Core/Board/CellDescriptors/ClassicDescriptors/Swordman/swordman_basic_descriptor.tres")

var _vertical_descriptor_lvl_1 = load("res://Core/Board/CellDescriptors/ClassicDescriptors/Swordman/swordman_vertical_descriptor_lvl_1.tres")
var _horizontal_descriptor_lvl_1 = load("res://Core/Board/CellDescriptors/ClassicDescriptors/Swordman/swordman_descriptor_lvl_1.tres")
var _directions_lvl_1 = [_horizontal_descriptor_lvl_1, _vertical_descriptor_lvl_1,]

var _vertical_descriptor_lvl_2 = load("res://Core/Board/CellDescriptors/ClassicDescriptors/Swordman/swordman_vertical_descriptor_lvl_2.tres")
var _horizontal_descriptor_lvl_2 = load("res://Core/Board/CellDescriptors/ClassicDescriptors/Swordman/swordman_descriptor_lvl_2.tres")
var _directions_lvl_2 = [_horizontal_descriptor_lvl_2, _vertical_descriptor_lvl_2,]

var _vertical_descriptor_lvl_3 = load("res://Core/Board/CellDescriptors/ClassicDescriptors/Swordman/swordman_vertical_descriptor_lvl_3.tres")
var _horizontal_descriptor_lvl_3 = load("res://Core/Board/CellDescriptors/ClassicDescriptors/Swordman/swordman_descriptor_lvl_3.tres")
var _directions_lvl_3 = [_horizontal_descriptor_lvl_3, _vertical_descriptor_lvl_3,]

func _ready():
	super._ready()
	self.level_1_descriptors = [_basic_descriptor, _directions_lvl_1[0]]
	self.level_cell_descriptors = self.level_1_descriptors


func _on_match_ended():
	#_direction_index+=1
	
	if self.level == 1:
		self.level_1_descriptors = [_basic_descriptor, _directions_lvl_1[GameManager.map.matchi % 2]]
		self.level_cell_descriptors = self.level_1_descriptors
	elif self.level == 2:
		self.level_2_descriptors = [_basic_descriptor, _directions_lvl_2[GameManager.map.matchi % 2]]
		self.level_cell_descriptors = self.level_2_descriptors
	else:
		self.level_3_descriptors = [_basic_descriptor, _directions_lvl_3[GameManager.map.matchi % 2]]
		self.level_cell_descriptors = self.level_3_descriptors
	super._on_match_ended()
	

