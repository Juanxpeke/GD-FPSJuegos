class_name PassiveSkillsList
extends ItemList

var tooltip_scene: PackedScene = preload("res://Core/UI/HUD/PlayerInterface/skill_tooltip.tscn")

var player: Player

# Private

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	item_selected.connect(_on_skill_selected)

# Called when a skill is selected
func _on_skill_selected(item_id : int) -> void:
	deselect_all()

# Creates a custom tooltip
func _make_custom_tooltip(for_text: String) -> Object:
	var new_tooltip: Control = tooltip_scene.instantiate()
	
	var skill_data = get_item_metadata(int(for_text))
	
	new_tooltip.set_skill_data(skill_data.name, skill_data.description)
	
	return new_tooltip

# Updates the layout
func _update_layout() -> void:
	for i in range(item_count):
		if i >= player.get_skills().size():
			break
		
		var skill = player.get_skills()[i]
		set_item_icon(i, skill.icon)
		set_item_metadata(i, { "name": skill.name, "description": skill.description })
		set_item_tooltip(i, str(i))


# Public

# Sets the player
func set_player(player: Player) -> void:
	self.player = player
	player.skills_changed.connect(_update_layout)
	GameManager.map.skill_activated.connect(_update_layout)
	_update_layout()
