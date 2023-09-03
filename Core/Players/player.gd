class_name Player
extends Node2D

@export var king_unit_scene: PackedScene

var enemy_player: Player

var pieces_scenes: Dictionary = {
	"king": "res://Core/Units/king.tscn",
	"bishop": "res://Core/Units/bishop.tscn",
}
var position_unit_array: Array[Array] = [
	["king", Vector2(0, 0)],
	["bishop", Vector2(-30, 0)],
	["bishop", Vector2(30, 0)],
]
# Public

# Sets up the multiplayer data for the player node
func multiplayer_setup(peer_player: MultiplayerManager.PeerPlayer):
	name = "Player" + str(peer_player.id)
	for i in range(position_unit_array.size()):
		var offset = position_unit_array[i][1]
		var piece_name = position_unit_array[i][0]
		
		var unit = load(pieces_scenes[piece_name]).instantiate() # cant preload as cell_descriptors get added before GameManager
		
		add_child(unit)
		
		unit.name = unit.unit_name + str(i) + str(peer_player.id)
		
		if multiplayer.get_unique_id() == peer_player.id:
			unit.position = GameManager.map.get_initial_king_position() + offset
		else:
			unit.position = GameManager.board.get_mirror_position(GameManager.map.get_initial_king_position() + offset)
		
	set_multiplayer_authority(peer_player.id)
	GameManager.set_board(GameManager.board) # unit's cell_descriptors aren't updating as board was set before

# Gets units
func get_units() -> Array:
	return get_children()
	
# Gets a unit by the given cell
func get_unit_by_cell(cell: Vector2i) -> Unit:
	var units = get_units()
	for unit in units:
		if GameManager.board.get_cell(unit.position) == cell:
			return unit
	return null

# Get all the players units cells
func get_all_units_cells() -> Array[Vector2i]:
	var units_cells = []
	var units = get_units()
	
	for unit in units:
		units_cells += unit.get_movement_cells()
	
	return units_cells

# Tries to kill the unit in the given cell
func receive_attack_in_cell(cell: Vector2i) -> void:
	var units = get_units()
	for unit in units:
		if GameManager.board.get_cell(unit.position) == cell:
			unit.die()
			return
