extends TextureButton

static var tooltip_scene: PackedScene = preload("res://Core/UI/HUD/PlayerInterface/skill_tooltip.tscn")

func _make_custom_tooltip(for_text: String) -> Object:
	var new_tooltip: Control = tooltip_scene.instantiate()
	
	var skill : ResActiveSkill = get_parent().get_parent().player.active_skills[int(for_text)]
	
	new_tooltip.set_skill_data(skill.name, skill.description)
	
	return new_tooltip
