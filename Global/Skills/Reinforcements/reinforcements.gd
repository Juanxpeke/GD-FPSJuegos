extends ResSkill

@export var unit_class : String
var player : Player
@export var TURNS_BETWEEN_EFFECT : int
var _turns_passed : int = 0

func _init() -> void:
	GameManager.map.player_turn_ended.connect(end_turn)
	GameManager.map.match_ended.connect(reset)
	
func end_turn(turnplayer: Player) -> void:
	if turnplayer != player:
		return
	_turns_passed+=1
	#MultiplayerManager.log_msg("turn passed: %d" % _turns_passed)
	if (_turns_passed % TURNS_BETWEEN_EFFECT == 0):
		activate()
	
func reset() -> void:
	_turns_passed = 0
		
func add_to_player(p: Player) -> void:
	p.skills.append(self)
	player = p
	
func activate() -> void:
	var base_cells = GameManager.board.get_base_cells()
	
	for base_cell in base_cells:
		var clear = true
		for p in GameManager.map.get_players():
			if p.get_live_unit_by_cell(base_cell):
				clear = false
				break
		if !clear: continue
		var unit_position = GameManager.board.get_cell_center(base_cell)
		player.spawn_unit.rpc(unit_class, unit_position)
		MultiplayerManager.log_msg("unit spawned")
		return
