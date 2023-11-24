extends Control

@onready var active_button := %ActiveButton
@onready var cooldown_label := %CooldownLabel

# Private

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	active_button.pressed.connect(_on_pressed)

# Called when the active button is pressed
func _on_pressed() -> void:
	get_parent().skill_pressed.emit(get_index())

# Displays the active layout
func _display_active_layout(active_skill: ResActiveSkill) -> void:
	active_button.disabled = true
	active_button.texture_disabled = active_skill.icon
	active_button.texture_normal = active_skill.icon
	active_button.material.set_shader_parameter("monochrome", false)
	active_button.mouse_default_cursor_shape = Control.CURSOR_ARROW
	
	# TODO: Set ACTIVE SKILL BUTTON shader
	
	cooldown_label.text = str(0)
	cooldown_label.hide()
	
# Displays the activable layout
func _display_activable_layout(active_skill: ResActiveSkill) -> void:
	active_button.disabled = false 
	active_button.texture_disabled = active_skill.icon
	active_button.texture_normal = active_skill.icon
	active_button.material.set_shader_parameter("monochrome", false)
	active_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	
	cooldown_label.text = str(0)
	cooldown_label.hide()
	
# Displays the cooldown layout
func _display_cooldown_layout(active_skill: ResActiveSkill) -> void:
	active_button.disabled = true
	active_button.texture_disabled = active_skill.icon
	active_button.texture_normal = active_skill.icon
	active_button.material.set_shader_parameter("monochrome", true)
	active_button.mouse_default_cursor_shape = Control.CURSOR_ARROW
	
	cooldown_label.text = str(active_skill.cooldown_remaining)
	cooldown_label.show()


# Public

# Clears the button as it won't contain an active skill
func clear() -> void:
	active_button.disabled = true
	active_button.texture_disabled = get_parent().clear_texture
	active_button.texture_normal = get_parent().clear_texture
	active_button.mouse_default_cursor_shape = Control.CURSOR_ARROW
	
	cooldown_label.text = str(0)
	cooldown_label.hide()

# Sets the active skill
func set_active_skill(active_skill: ResActiveSkill) -> void:
	if active_skill.active:
		_display_active_layout(active_skill)
	elif active_skill.cooldown_remaining > 0:
		_display_cooldown_layout(active_skill)
	else:
		_display_activable_layout(active_skill)
