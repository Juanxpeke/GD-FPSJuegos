class_name SkillTooltip
extends Panel

@onready var name_label := %Name
@onready var description_label := %Description

# Private

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	pass # Replace with function 
	
# Public
 
# Sets the skill data
func set_skill_data(skill_name: String, skill_description: String) -> void:
	get_child(0).text = skill_name
	get_child(1).text = skill_description
