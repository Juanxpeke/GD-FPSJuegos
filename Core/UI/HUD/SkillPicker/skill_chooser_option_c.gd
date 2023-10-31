class_name SkillOption
extends VBoxContainer

var skill_id: int
var selectable: bool = true

@onready var skill_icon: TextureRect = %SkillIcon
@onready var skill_description: Label = %SkillDescription
@onready var animation_player: AnimationPlayer = %AnimationPlayer

# Private

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	self.modulate.a = 140.0 / 255.0;
	
	_update_layout()
	
# Called when the mouse enters the skill option
func _on_mouse_entered():
	if !selectable: return
	self.modulate = self.modulate * 1.2;
	self.modulate.a = 1;

# Called when the mouse exits the skill option
func _on_mouse_exited():
	if !selectable: return
	self.modulate = self.modulate / 1.2;
	self.modulate.a = 140.0 / 255;

# Called on GUI input
func _gui_input(event: InputEvent) -> void:
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

# Selects the skill
func select():
	if !selectable: return

	selectable = false
	get_parent().get_parent().spread_selection(self)
	
	animation_player.play("selected")
	animation_player.animation_finished.connect(
		func(_anim_name):
			get_parent().get_parent().skill_selected = true 
			get_parent().get_parent().hide()
	)
	
	GameManager.player.add_skill.rpc(skill_id)
	
	MultiplayerManager.log_msg("skill option selected %d" % skill_id)
	
# Unselects the skill
func unselect():
	selectable = false
	animation_player.play("unselected")
