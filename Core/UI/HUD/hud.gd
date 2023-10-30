class_name HUD
extends CanvasLayer

var timer_on: bool = false

@onready var player_interface: PlayerInterface = %PlayerInterface
@onready var enemy_interface: PlayerInterface = %EnemyInterface
@onready var store: Store = %Store
@onready var preparation_time_bar: TextureProgressBar = %PreparationTimeBar
@onready var preparation_timer: Timer = %PreparationTimer

# Private

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.map_initialized.connect(
		func():
			set_preparation_time(GameManager.map.preparation_time)
			
			timer_on = true
			preparation_timer.start()
			
			await get_tree().create_timer(0.2).timeout
			
			player_interface.set_player(GameManager.player)
			enemy_interface.set_player(GameManager.player.enemy_player)
			
			GameManager.map.preparation_ended.connect(_on_preparation_ended)
			GameManager.map.match_ended.connect(_on_match_ended)
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if timer_on:
		preparation_time_bar.value = preparation_timer.time_left

# Called when the preparation phase ends
func _on_preparation_ended() -> void:
	timer_on = false
	preparation_timer.stop()
	preparation_time_bar.hide()
	_hide_store()
	
# Called when the battle phase ends
func _on_match_ended() -> void:
	timer_on = true
	preparation_timer.start()
	preparation_time_bar.show()
	_show_store()

# Hides the store
func _hide_store() -> void:
	store.hide()

# Shows the store
func _show_store() -> void:
	store.show()

# Public

# Sets the preparation time
func set_preparation_time(time: float) -> void:
	preparation_time_bar.max_value = time
	preparation_time_bar.value = time
	preparation_timer.wait_time = time
