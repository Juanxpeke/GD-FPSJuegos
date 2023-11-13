class_name SkillPicker
extends Panel

@export var skill_option_scene: PackedScene

var initial_skill_options: int
var skill_selected: bool = false

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

@onready var skills_options_container := %SkillsOptionsContainer
@onready var skill_picking_timer := %SkillPickingTimer

# Private

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	rng.randomize()
	
	initial_skill_options = skills_options_container.get_child_count()
	
	skill_picking_timer.timeout.connect(_on_skill_picking_timeout)
	
	hide()
	
# Called when the skill picking timer timeouts
func _on_skill_picking_timeout() -> void:
	if not skill_selected:
		select_random_skill()
	
# Public

# Sets the skill picking time
func set_skill_picking_time(time: float) -> void:
	skill_picking_timer.wait_time = time

# Shows random skills for the player to select
func show_skills() -> void:
	var skill_id_pool = GameManager.player.get_skill_id_pool()
	skill_id_pool.shuffle()
	
	if skill_id_pool.is_empty():
		MultiplayerManager.log_msg("show skills empty")
		return
	
	MultiplayerManager.log_msg("show skills (skill id pool %s)" % str(skill_id_pool))
	
	add_extra_skill_options()
	
	for i in range(skills_options_container.get_child_count()):
		if i < skill_id_pool.size():
			var skill_id = skill_id_pool[i]
			skills_options_container.get_child(i).set_skill_id(skill_id)
			skills_options_container.get_child(i).reset()
		else:
			skills_options_container.get_child(i).hide()
	
	skill_selected = false
	skill_picking_timer.start()
	show()

# Selects a random skill
func select_random_skill() -> void:
	MultiplayerManager.log_msg("select random skill")
	
	var visible_skill_options = []
	for skill_option in skills_options_container.get_children():
		if skill_option.visible:
			visible_skill_options.append(skill_option)
	
	var random_index = rng.randi_range(0, visible_skill_options.size() - 1) 
	visible_skill_options[random_index].select()

# Unselects the skill options that were not selected
func spread_selection(skill_option : SkillOption) -> void:
	skill_selected = true
	for option in skills_options_container.get_children():
		if option != skill_option:
			option.unselect()

# Adds the given amount of extra skill options
func add_extra_skill_options() -> void:
	var extra_skill_options = 0
	for skill in GameManager.player.skills:
		extra_skill_options += skill.extra_skill_options
		
	for i in range(extra_skill_options):
		var skill_option = skill_option_scene.instantiate()
		skills_options_container.add_child(skill_option)
	
	skills_options_container.add_theme_constant_override("separation", max(64 - extra_skill_options * 32, 8))
	
# Clears all the extra skill options
func clear_extra_skill_options() -> void:
	for i in range(skills_options_container.get_child_count()):
		if i >= initial_skill_options:
			skills_options_container.get_child(i).queue_free()
	
	skills_options_container.add_theme_constant_override("separation", 64)
