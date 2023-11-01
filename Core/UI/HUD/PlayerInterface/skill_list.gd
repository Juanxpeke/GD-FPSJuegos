extends ItemList
class_name SkillList

var displayed_skills: Array[ResSkill] = []
var player: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gui_input.connect(_on_ItemList_gui_input)
	item_selected.connect(_on_skill_selected)


func _on_ItemList_gui_input(event: InputEvent) -> void:
	var item = get_item_at_position(get_local_mouse_position(), true)
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		if item != -1:
			pass

func _on_skill_selected(item_id : int) -> void:
	deselect_all()
	if player == GameManager.player:
		player.activate_skill.rpc(item_id)

func _set_player_skills() -> void:
	clear() # vacia lista
	var count: int= 0
	for skill in player.get_skills() + player.activable_skills: # REVIEW: + player.activable_skills:
		add_item(skill.name, skill.icon)
		set_item_tooltip(count, skill.description)
		displayed_skills.append(skill)
		count+=1

func set_player(player: Player) -> void:
	self.player = player
	player.skills_changed.connect(_set_player_skills)
	_set_player_skills()
