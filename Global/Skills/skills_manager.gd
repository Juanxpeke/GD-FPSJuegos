extends Node

# All skills in game
var skills = [
	# Passives
	"res://Global/Skills/DimensionalJump/dimensional_jump.tres",
	"res://Global/Skills/JumperAscension/jumper_ascension.tres",
	# Consumables
	"res://Global/Skills/Consumables/PirateFortune/pirate_fortune.tres",
	"res://Global/Skills/Consumables/JumperLevelUp/jumper_level_up.tres",
	# Actives
	"res://Global/Skills/Actives/Ghost/ghost.tres",
	"res://Global/Skills/Actives/Reinforcements/reinforcements.tres",
	"res://Global/Skills/Actives/DimensionalJump/dimensional_jump_v.tres",
]

# Public

# Gets the skill parameters given a skill id
func get_skill(skill_id: int) -> ResSkill:
	assert(skill_id > -1 and skill_id < skills.size(), "invalid skill id")
	return load(skills[skill_id]).duplicate()
