class_name SkillListsContainer
extends Panel

var tooltip_scene: PackedScene = preload("res://Core/UI/HUD/PlayerInterface/skill_tooltip.tscn")

@onready var passive_skills_list: SkillList = %PassiveSkillsList
@onready var active_skills_list: SkillList = %ActiveSkillsList

# Private

# Creates a custom tooltip
func _make_custom_tooltip(for_text: String) -> Object:
	var new_tooltip: Control = tooltip_scene.instantiate()
	var parsed_text = for_text.split("|||")
	
	new_tooltip.set_skill_data(parsed_text[0], parsed_text[1])
	
	return new_tooltip

# Public

# Sets the player
func set_player(player: Player) -> void:
	passive_skills_list.set_player(player)
	active_skills_list.set_player(player)

