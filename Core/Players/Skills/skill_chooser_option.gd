extends VBoxContainer
class_name skillOption

@onready var image : TextureRect = %TextureRect
@onready var description : Label = %Label
@onready var animation_player : AnimationPlayer = $AnimationPlayer
var skill_attached : Skill
var skill_index : int
var selectable = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)
	self.modulate.a = 140.0/255.0;
	description.text = skill_attached.description
	image.texture = load(skill_attached.texture_path)

# private, catch signals
func _on_mouse_entered():
	if !selectable:
		return
	self.modulate = self.modulate * 1.2;
	self.modulate.a = 1;
	
func _on_mouse_exited():
	if !selectable:
		return
	self.modulate = self.modulate / 1.2;
	self.modulate.a = 140.0/255;


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		select()

func select():
	if !selectable:
		return
	selectable = false
	GameManager.player.add_skill.rpc(skill_index)
	print("skill elegida, ", skill_attached)
	play_selected()
	get_parent().option_selected(self)

# when panel is created, each container should be setted a skill
func set_skill(skill_and_index: Array) -> void:
	skill_attached = skill_and_index[0]
	skill_index = skill_and_index[1]

func play_selected() -> void:
	selectable = false
	animation_player.play("selected")

func play_unselected() -> void:
	selectable = false
	animation_player.play("unselected")
	

func close():
	self.get_parent().queue_free()
