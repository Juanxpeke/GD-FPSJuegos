extends Node

# All roles in game
var role_a: Role = load("res://Global/Roles/pirate.tres")
var role_b: Role = load("res://Global/Roles/medieval_knight.tres")

# Unit dimensions on all texture atlases
var texture_atlas_unit_dimensions: Vector2 = Vector2(16, 18)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Public

# Gets the role parameters given a role enum
func get_role(role_enum: GameManager.RoleEnum) -> Role:
	match role_enum:
		GameManager.RoleEnum.ROLE_A:
			return role_a
		GameManager.RoleEnum.ROLE_B:
			return role_b
	return role_a
	
# Gets the unit dimensions in the roles texture atlases
func get_texture_atlas_unit_dimensions() -> Vector2:
	return texture_atlas_unit_dimensions

# Gets the given unit offset in the roles texture atlases, using coordinates
func get_texture_atlas_unit_offset_coords(unit_class: String) -> Vector2:
	match unit_class:
		"king":
			return Vector2(4, 0)
		"bishop":
			return Vector2(3, 0)
		"knight":
			return Vector2(1, 0)
		"mage":
			return Vector2(0, 0)
		"jumper":
			return Vector2(0, 0)
	return Vector2()

# Gets the given unit offset in the roles texture atlases
func get_texture_atlas_unit_offset(unit_class: String) -> Vector2:
	return get_texture_atlas_unit_offset_coords(unit_class) * texture_atlas_unit_dimensions
