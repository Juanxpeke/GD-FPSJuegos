extends Label

var unit_cost: int = 0
var unit_name: String

@onready var unit_button: TextureButton = %UnitButton


# Called when the node enters the scene tree for the first time.
func _ready():
	unit_button.pressed.connect(_on_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_pressed():
	print("dddd")
	if unit_cost > 0:
		print("asd")
		unit_button.disabled = true
		self.visible = false
		GameManager.player.spawn_unit(unit_name)
		
func set_unit(unit_name: String, cost: int):
	#unit_button.texture_normal = load("res://icon.svg")
	unit_button.set_texture_normal(load("res://icon.svg"))
	self.text = str(cost)
	unit_cost = cost
	unit_name = unit_name
