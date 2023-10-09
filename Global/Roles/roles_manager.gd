extends Node

# All roles in game
var role_a: Role = load("res://Global/Roles/pirate.tres")
var role_b: Role = load("res://Global/Roles/medieval_knight.tres")

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

# Gets the given unit offset in the role texture atlas
func get_texture_atlas_unit_offset(unit_class: String) -> Vector2:
	match unit_class:
		"king":
			return Vector2(16 * 2, 0)
		"bishop":
			return Vector2(16 * 3, 0)
		"knight":
			return Vector2(16 * 4, 0)
	return Vector2()
