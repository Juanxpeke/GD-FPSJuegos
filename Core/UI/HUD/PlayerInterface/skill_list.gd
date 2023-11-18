extends ItemList
class_name SkillList

var displayed_skills: Array[ResSkill] = []
var player: Player


func _set_player_skills() -> void:
	clear() # vacia lista
	var count: int= 0
	for skill in player.get_skills():
		add_item(skill.name, skill.icon)
		set_item_tooltip(count, skill.name+"|||"+skill.description)
		displayed_skills.append(skill)
		count+=1

func set_player(player: Player) -> void:
	self.player = player
	player.skills_changed.connect(_set_player_skills)
	_set_player_skills()
	
func _make_custom_tooltip(for_text: String) -> Object:
	return get_parent()._make_custom_tooltip(for_text)
