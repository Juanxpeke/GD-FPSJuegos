extends Node

# All roles in game
var roles = [
	load("res://Global/Roles/MedievalKnight/medieval_knight.tres"),
	load("res://Global/Roles/Pirate/pirate.tres"),
]

# Unit dimensions on all texture atlases
var texture_atlas_unit_dimensions: Vector2 = Vector2(16, 18)

# Public

# Gets the role parameters given a role enum
func get_role(role_id: int) -> Role:
	assert(role_id > -1 and role_id < roles.size(), "invalid role id")
	return roles[role_id]
	
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

# Gets the given unit texture by the given role
func get_unit_texture(unit_class: String, role_id: int) -> AtlasTexture:
	var unit_offset = get_texture_atlas_unit_offset(unit_class)
	var unit_dimensions = get_texture_atlas_unit_dimensions()
	
	var texture = AtlasTexture.new() 
	texture.atlas = get_role(role_id).units_texture_atlas
	texture.region = Rect2(unit_offset.x, unit_offset.y, unit_dimensions.x, unit_dimensions.y)
	
	return texture
