extends Control

class_name Store

@onready var current_money = $Panel/VBoxContainer/CurrentMoney

var unit_costs: Dictionary = {
	"pawn": {"cost": 1, "probability": 0.4},
	"knight": {"cost": 2, "probability": 0.2},
	"queen": {"cost": 4, "probability": 0.1},
	"bishop": {"cost": 3, "probability": 0.3}
}

var current_piece_set: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.set_store(self)
	initialize_store()
	var player = MultiplayerManager.get_current_peer_player()
	var role = GameManager.get_role(player.role)
	var money = role.initial_money
	current_money.text = "Monedas: " + str(money)
	
	player.connect("money_changed", _on_money_changed)
	
func _on_money_changed(new_money: int):
	current_money = "Monedas: " + str(new_money)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func initialize_store():
	unit_costs["pawn"]["cost"] = 1
	unit_costs["knight"]["cost"] = 2
	unit_costs["queen"]["cost"] = 4
	unit_costs["bishop"]["cost"] = 3

	choose_random_piece_set()
	
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
