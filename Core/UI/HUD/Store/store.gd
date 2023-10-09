class_name Store
extends PanelContainer

var player: Player = null
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

@onready var money_label = %MoneyLabel
@onready var store_unit_container = %StoreUnitContainer

# Private

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	
	GameManager.set_store(self)
	GameManager.map_initialized.connect(_on_map_initialized)
	GameManager.player_initialized.connect(_on_player_initialized)
	update_store()
	
# Called when the map is initialized
func _on_map_initialized() -> void:
	GameManager.map.match_ended.connect(_on_match_ended)
	
# Called when the player is initialized
func _on_player_initialized() -> void:
	GameManager.player.money_changed.connect(_on_money_changed)
	_update_player_information()

# Called when the player money changes
func _on_money_changed():
	_update_player_information()
	
# Called when the match ends
func _on_match_ended() -> void:
	update_store()

# Updates the store with the player information
func _update_player_information() -> void:
	money_label.text = "Monedas: " + str(GameManager.player.current_money)
	
# Public
	
# Updates the store
func update_store():
	var store_units_count = store_unit_container.get_child_count()
	var random_unit_set = get_random_unit_set(store_units_count)
	
	for i in range(store_units_count):
		store_unit_container.get_child(i).set_unit(random_unit_set[i])

# Gets a random unit set
func get_random_unit_set(unit_count: int) -> Array:
	var game_phase = GameManager.get_phase()
	var random_unit_set = []
	var total_units_weight = GameManager.units_data.keys().reduce(
		func(accum, key): return accum + GameManager.units_data[key].weights[game_phase], 0)
	
	for i in range(unit_count):
		var random_unit_weigth = rng.randi_range(0, total_units_weight)
		var cumulative_weight = 0

		for unit_class in GameManager.units_data:
			cumulative_weight += GameManager.units_data[unit_class].weights[game_phase]
			if random_unit_weigth <= cumulative_weight:
				random_unit_set.append(unit_class)
				break
				
	return random_unit_set
	
