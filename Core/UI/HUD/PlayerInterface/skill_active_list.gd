class_name SkillActiveList
extends SkillList

# Private

# Called when a skill is selected
func _on_skill_selected(item_id : int) -> void:
	super._on_skill_selected(item_id)
	
	if player == GameManager.player:
		player.activate_skill.rpc(item_id)

# Updates the layout
func _update_layout() -> void:
	clear() # vacia lista
	var count: int= 0
	for skill in player.activable_skills: # REVIEW: + player.activable_skills:
		add_item(skill.name, skill.icon)
		set_item_tooltip(count, skill.description)
		count += 1
