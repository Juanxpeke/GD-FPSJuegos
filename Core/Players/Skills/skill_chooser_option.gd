extends VBoxContainer

@onready var image : TextureRect = $TextureRect
@onready var description : Label = $Label
var skill_attached : Skill

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)
	self.modulate.a = 140.0/255.0;
	description.text = skill_attached.description
	image.texture = load(skill_attached.texture_path)

# private, catch signals
func _on_mouse_entered():
	self.modulate = self.modulate * 1.2;
	self.modulate.a = 1;
	
func _on_mouse_exited():
	self.modulate = self.modulate / 1.2;
	self.modulate.a = 140.0/255;


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		GameManager.player.add_skill.rpc(skill_attached)
		print("skill elegida, ", skill_attached)
		get_parent().queue_free()

# when panel is created, each container should be setted a skill
func set_skill(skill: Skill) -> void:
	skill_attached = skill


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
