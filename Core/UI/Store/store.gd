extends Control

class_name Store

var unit_costs: Dictionary = {
	"pawn": {"cost": 1, "probability": 0.4},
	"knight": {"cost": 2, "probability": 0.2},
	"queen": {"cost": 4, "probability": 0.1},
	"bishop": {"cost": 3, "probability": 0.3}
}

var current_piece_set: Array = []
var random_unit_classes: Array = []

var player: Player = null

@onready var current_money = %CurrentMoney
@onready var store_unit_container = %StoreUnitContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.set_store(self)
	GameManager.player_initialized.connect(_on_player_initialized)
	initialize_store()
	
# Called when the player is initialized
func _on_player_initialized() -> void:
	GameManager.player.money_changed.connect(_on_money_changed)
	_update_player_information()

# Called when the player money changes
func _on_money_changed():
	_update_player_information()

# Updates the store with the player information
func _update_player_information() -> void:
	current_money.text = "Monedas: " + str(GameManager.player.current_money)
	
func initialize_store():
	unit_costs["pawn"]["cost"] = 1
	unit_costs["knight"]["cost"] = 2
	unit_costs["queen"]["cost"] = 4
	unit_costs["bishop"]["cost"] = 3

	choose_random_piece_set()
	
	for i in range(current_piece_set.size()):
		var unit_name = current_piece_set[i]
		var cost = unit_costs[unit_name]["cost"]
		store_unit_container.get_child(i).set_unit(unit_name, cost)
	
func get_unit_cost(unit_type: String) -> int:
	return unit_costs.get(unit_type, {"cost": 0})["cost"]
	
func choose_random_piece_set():

	var set_size = 3  # Tamaño del conjunto de piezas
	current_piece_set.clear()

	for i in range(set_size):
		var rand = randf()
		var cumulative_probability = 0.0

		for piece_type in unit_costs:
			var data = unit_costs[piece_type]
			cumulative_probability += data["probability"]
			if rand <= cumulative_probability:
				current_piece_set.append(piece_type)
				
				break

func adjust_probabilities():
	unit_costs["pawn"]["probability"] -= 0.1
	unit_costs["knight"]["probability"] += 0.1
	unit_costs["queen"]["probability"] += 0.05
	unit_costs["bishop"]["probability"] += 0.05

func on_match_ended() -> void:
	adjust_probabilities()
	# Borrar los stores units
	choose_random_piece_set()
	initialize_store()
	
