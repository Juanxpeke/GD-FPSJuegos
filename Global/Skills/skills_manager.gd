extends Node

# All skills in game
var skills = [
	# Passives
	"res://Global/Skills/Stonks/stonks.tres",
	"res://Global/Skills/BishopAscension/bishop_ascension.tres",
	"res://Global/Skills/KnightAscension/knight_ascension.tres",
	"res://Global/Skills/RookAscension/rook_ascension.tres",
	# "res://Global/Skills/JumperAscension/jumper_ascension.tres",
	# "res://Global/Skills/Reinforcements/reinforcements.tres", # disabled because 2manybugs
	# Consumables
	# "res://Global/Skills/Consumables/PirateFortune/pirate_fortune.tres",
	"res://Global/Skills/Consumables/BishopLevelUp/bishop_level_up.tres",
	"res://Global/Skills/Consumables/KnightLevelUp/knight_level_up.tres",
	"res://Global/Skills/Consumables/RookLevelUp/rook_level_up.tres",
	# "res://Global/Skills/Consumables/JumperLevelUp/jumper_level_up.tres",
	# Actives
	"res://Global/Skills/Actives/Ghost/ghost.tres",
	"res://Global/Skills/Actives/DimensionalJump/dimensional_jump_v.tres",
	"res://Global/Skills/Actives/DimensionalJump/dimensional_jump.tres",
]

# Public

# Gets the skill parameters given a skill id
func get_skill(skill_id: int) -> ResSkill:
	assert(skill_id > -1 and skill_id < skills.size(), "invalid skill id")
	var skill : ResSkill = load(skills[skill_id]).duplicate()
	skill.format_description()
	return skill
	
