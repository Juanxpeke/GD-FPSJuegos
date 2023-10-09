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
