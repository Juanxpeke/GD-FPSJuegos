extends ItemList
class_name SkillList

var displayed_skills: Array[ResSkill] = []
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
	return get_parent()._make_custom_tooltip(for_text)

# Updates the layout
func _update_layout() -> void:
	clear() # Empty the list
	var count: int = 0
	for skill in player.get_skills():
		add_item('', skill.icon)
		set_item_tooltip(count, skill.name + "|||" + skill.description)
		displayed_skills.append(skill)
		count += 1

# Public

# Sets the player
func set_player(player: Player) -> void:
	self.player = player
	player.skills_changed.connect(_update_layout)
	_update_layout()
