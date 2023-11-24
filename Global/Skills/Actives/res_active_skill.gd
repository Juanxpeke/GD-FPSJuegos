class_name ResActiveSkill
extends ResSkill

var player : Player
var index_in_skill_array : int

## Number of turns that have to pass between skill activation
@export var COOLDOWN: int = 0 
## Number of turns the skill take effect after activation
@export var TURNS_ACTIVE: int = 1
## How many times the skill can be used each round
@export var INITIAL_USES: int = 9999

var cooldown_remaining: int = 0
var active_turns_count: int = 0
var uses_remaining: int = 0
var active: bool

# Private

# Constructor
func _init() -> void:
	active = false
	GameManager.map_initialized.connect(
		func():
			GameManager.map.player_turn_ended.connect(self.end_turn)
			GameManager.map.match_ended.connect(self.reset)
	)

	uses_remaining = INITIAL_USES


# Public
	
func set_index(index : int):
	index_in_skill_array = index

func end_turn(player: Player) -> void:
	if player != GameManager.player:
		return
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

# Activates the skill
func activate() -> bool:
	if cooldown_remaining <= 0 and uses_remaining > 0 and not active:
		uses_remaining -= 1
		active = true
		
		MultiplayerManager.log_msg('activate %s' % self.name)
		return true
	
	MultiplayerManager.log_msg('fail activate %s' % self.name)
	return false

# Deactives
func deactivate() -> void:
	active = false
	active_turns_count = 0
	cooldown_remaining = COOLDOWN
	
	player.deactivate_skill(index_in_skill_array)
	
	MultiplayerManager.log_msg("deactivate %s" % self.name)

# Adds itself to the player
func add_to_player(player: Player) -> void:
	self.player = player
	player.active_skills.append(self)
