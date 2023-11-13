class_name SkillOption
extends Control

var skill_id: int
var selectable: bool = true

@onready var skill_info_panel: PanelContainer = %SkillInfoPanel
@onready var skill_icon: TextureRect = %SkillIcon
@onready var skill_description: Label = %SkillDescription
@onready var animation_player: AnimationPlayer = %AnimationPlayer

# Private

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	skill_info_panel.mouse_entered.connect(_on_mouse_entered)
	skill_info_panel.mouse_exited.connect(_on_mouse_exited)
	skill_info_panel.gui_input.connect(_on_gui_input)
	animation_player.animation_finished.connect(_on_animation_finished)
	
	_update_layout()
	
# Called when the mouse enters the skill option
func _on_mouse_entered():
	if !selectable: return
	self.modulate = self.modulate * (255.0 / 225.0);

# Called when the mouse exits the skill option
func _on_mouse_exited():
	if !selectable: return
	self.modulate = self.modulate * (225.0 / 255.0);

# Called on animation finished
func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "selected":
		get_parent().get_parent().hide()
		get_parent().get_parent().clear_extra_skill_options()

# Called on GUI input
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		select()
		
# Updates the layout
func _update_layout() -> void:
	var skill = SkillsManager.get_skill(skill_id)
	skill_icon.texture = skill.icon
	skill_description.text = skill.description

# Public

# Sets the skill
func set_skill_id(skill_id: int) -> void:
	self.skill_id = skill_id
	_update_layout()

# Resets the skill option
func reset() -> void:
	selectable = true
	animation_player.play("RESET")
	show()

# Selects the skill
func select():
	if !selectable: return

	MultiplayerManager.log_msg("skill option selected %d" % skill_id)
	
	selectable = false
	get_parent().get_parent().spread_selection(self)
	
	animation_player.play("selected")
	
	GameManager.player.add_skill.rpc(skill_id)

# Unselects the skill
func unselect():
	selectable = false
	animation_player.play("unselected")
