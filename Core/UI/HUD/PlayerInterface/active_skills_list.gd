class_name ActiveSkillsList
extends HBoxContainer

signal skill_pressed(index: int)

@export var clear_texture: Texture2D

var player: Player

# Private

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	skill_pressed.connect(_on_skill_pressed)

# Called when a skill is pressed
func _on_skill_pressed(index: int) -> void:
	if player == GameManager.player:
		player.activate_skill.rpc(index)

# Updates the layout
func _update_layout() -> void:
	for i in range(get_child_count()):
		var active_skill_button = get_child(i)
		
		if i >= player.get_active_skills().size():
			active_skill_button.clear()
		else:
			var active_skill = player.get_active_skills()[i]
			active_skill_button.set_active_skill(active_skill)

# Public

# Sets the player
func set_player(player: Player) -> void:
	self.player = player
	player.skills_changed.connect(_update_layout)
	GameManager.map.skill_activated.connect(_update_layout)
	_update_layout()
