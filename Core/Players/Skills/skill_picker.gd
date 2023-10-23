extends CanvasLayer
class_name SkillPicker

@export var skill_option_scene : PackedScene = preload("res://Core/Players/Skills/skill_option_container.tscn")
@export var options_n : int

var choices : Array[skillOption] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var skill_pool : Array = GameManager.player.get_skill_pool() #Array[(Skill, int)]
	skill_pool.shuffle()
	print(skill_pool)
	for i in range(0, options_n):
		var container : VBoxContainer = skill_option_scene.instantiate()
		var skill = skill_pool[i]
		var width = get_viewport().get_visible_rect().size.x
		var height = get_viewport().get_visible_rect().size.y
		var padding = 0.3 * width / options_n
		var separation = (width - options_n * container.size.x - 2 * padding) / (options_n-1)
		container.position = Vector2(padding + (separation+container.size.x) * i, height / 2 - container.size.y / 2)
		
		print(skill)
		container.set_skill(skill)
		add_child(container)
		
		choices.append(container)

# elimina el nodo de la escene y elije una skill aleatoria 
func force_close() -> void:
	print("FORCE CLOSE")
	choices.shuffle()
	var container = choices[0]
	container.select()

# corre la animacion de choices que no fueron elegidas
func option_selected(option : skillOption) -> void:
	for choice in choices:
		if !(choice == option):
			choice.play_unselected()
