extends CanvasLayer
class_name SkillPicker

@export var skill_option_scene = preload("res://Core/Players/Skills/skill_option_container.tscn")
@export var options_n =  3

var skill_pool : Array[Skill] = [
	Ghost.new(), 
	DimensionalJump.new(),
	BishopLevelUp.new(),
	Skill.new(), #test claramente
]

var choices : Array[Skill] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(0, options_n):
		var container : VBoxContainer = skill_option_scene.instantiate()
		var skill = skill_pool[randi() % skill_pool.size()]
		var width = get_viewport().get_visible_rect().size.x
		var height = get_viewport().get_visible_rect().size.y
		var padding = 0.3 * width / options_n
		var separation = (width - 3 * container.size.x - 2 * padding) / (options_n-1)
		container.position = Vector2(padding + (separation+container.size.x) * i, height / 2 - container.size.y / 2)
		
		container.set_skill(skill)
		add_child(container)
		
		choices.append(skill)

# elimina el nodo de la escene y elije una skill aleatoria 
func force_close() -> void:
	print("FORCE CLOSE")
	var skill = choices[randi() % choices.size()]
	GameManager.player.add_skill.rpc(skill)
	self.queue_free()
