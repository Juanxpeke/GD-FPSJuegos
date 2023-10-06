extends Skill
class_name Active

var player : Player
var index_in_skill_array : int

var COOLDOWN : int = 0
var TURNS_ACTIVE : int = 1
var INITIAL_USES : int = 9999
var cooldown_remaining : int = 0
var active_turns_count : int = 0
var uses_remaining : int = 9999
var active : bool

func _init() -> void:
	self._initialize_attributes()
	active = false
	GameManager.map.turn_ended.connect(end_turn)
	GameManager.map.match_ended.connect(reset)
	uses_remaining = INITIAL_USES
	
# override this as init
func _initialize_attributes() -> void:
	pass

func activate() -> bool:
	if cooldown_remaining <= 0 and uses_remaining > 0 and not active:
		uses_remaining-=1
		active = true
		print("skill activated")
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
	
func reset() -> void:
	cooldown_remaining = 0
	active_turns_count = 0
	uses_remaining = INITIAL_USES
	if active:
		deactivate()

func deactivate() -> void:
	active = false
	active_turns_count = 0
	cooldown_remaining = COOLDOWN
	print("deactivate skill ", self.name)
	player.deactivate_skill(index_in_skill_array)

func add_to_player(p: Player) -> void:
	p.activable_skills.append(self)
	player = p
