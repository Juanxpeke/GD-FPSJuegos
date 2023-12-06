class_name HUD
extends CanvasLayer

var timer_on: bool = false

@onready var turn_label: Label = %TurnLabel
@onready var matchi_label: Label = %MatchiLabel
@onready var match_damage_label: Label = %MatchDamageLabel
@onready var match_reward_label: Label = %MatchRewardLabel
@onready var player_interface: PlayerInterface = %PlayerInterface
@onready var enemy_interface: PlayerInterface = %EnemyInterface
@onready var details_interface: DetailsInterface = %DetailsInterface
@onready var store: Store = %Store
@onready var skill_picker: SkillPicker = %SkillPicker
@onready var preparation_time_bar: TextureProgressBar = %PreparationTimeBar
@onready var preparation_timer: Timer = %PreparationTimer

# Private

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.map_initialized.connect(
		func():
			update_times()
			
			timer_on = true
			preparation_timer.start()
			
			await get_tree().create_timer(0.2).timeout
			
			match_damage_label.text = str(GameManager.phase_damages[GameManager.get_phase()])
			match_reward_label.text = str(GameManager.phase_rewards[GameManager.get_phase()])
			
			player_interface.set_player(GameManager.player)
			enemy_interface.set_player(GameManager.player.enemy_player)
			
			GameManager.map.preparation_ended.connect(_on_preparation_ended)
			GameManager.map.turn_ended.connect(_on_turn_ended)
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
	store.hide()
	
# Called when a turn ends
func _on_turn_ended() -> void:
	turn_label.text = str(GameManager.map.turn)
	
# Called when the battle phase ends
func _on_match_ended() -> void:
	turn_label.text = str(GameManager.map.turn)
	matchi_label.text = str(GameManager.map.matchi)
	match_damage_label.text = str(GameManager.phase_damages[GameManager.get_phase()])
	match_reward_label.text = str(GameManager.phase_rewards[GameManager.get_phase()])
	
	timer_on = true
	preparation_timer.start()
	preparation_time_bar.show()
	store.show()

# Public

# Updaets the preparation and skill picking time
func update_times() -> void:
	preparation_time_bar.max_value = GameManager.map.preparation_time
	preparation_time_bar.value = GameManager.map.preparation_time
	preparation_timer.wait_time = GameManager.map.preparation_time
	skill_picker.update_time()
	
# Shows the selectable skills
func show_skills() -> void:
	skill_picker.show_skills()

# Shows the given unit details
func show_unit_details(unit: Unit) -> void:
	details_interface.set_unit(unit)
	details_interface.show_details()

# Hides the unit details interface
func hide_unit_details() -> void:
	details_interface.hide_details()
