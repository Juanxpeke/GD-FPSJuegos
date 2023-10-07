extends Control
class_name SkillPicker

@export var skill_option_scene = preload("res://Core/Players/Skills/skill_option_container.tscn")

var skill_pool : Array[Skill] = [
	Ghost.new(), 
	DimensionalJump.new(),
	BishopLevelUp.new(),
	Skill.new(), #test claramente
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(0, 3):
		var container : VBoxContainer = skill_option_scene.instantiate()
		var skill = skill_pool[randi() % skill_pool.size()]
		container.position = Vector2(100+350*i, 132)
		container.set_skill(skill)
		add_child(container)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
