extends Node

# All skills in game
var skills = [
	"res://Global/Skills/JumperLevelUp/jumper_level_up.tres",
	"res://Global/Skills/DimensionalJump/dimensional_jump.tres",
	"res://Global/Skills/Ghost/ghost.tres"
]

# Public

# Gets the skill parameters given a skill id
func get_skill(skill_id: int) -> ResSkill:
	assert(skill_id > -1 and skill_id < skills.size(), "invalid skill id")
	return load(skills[skill_id]).duplicate()
