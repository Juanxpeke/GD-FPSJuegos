extends Skill
class_name Active

var player : Player
var index_in_skill_array : int

var COOLDOWN : int = 0
var TURNS_ACTIVE : int = 1
var cooldown_remaining : int = 0
var active_turns_count : int = 0
var uses_remaining : int = 9999
var active : bool

func _init(p: Player) -> void:
	player = p
	active = false
	GameManager.connect("turn_ended", end_turn)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func activate() -> bool:
	if cooldown_remaining <= 0 and uses_remaining > 0 and not active:
		uses_remaining-=1
		active = true
		return true
	return false
	
func set_index(index : int):
	index_in_skill_array = index

func end_turn() -> void:
	cooldown_remaining -= 1;
	if active:
		active_turns_count += 1;
		if active_turns_count >= TURNS_ACTIVE:
			deactivate()
	
func deactivate() -> void:
	active = false
	active_turns_count = 0
	cooldown_remaining = COOLDOWN
	player.deactivate_skill(index_in_skill_array)
