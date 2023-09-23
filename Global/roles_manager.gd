extends Node

# All roles in game
var role_a: Role
var role_b: Role

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	role_a = Role.new(
		"Role A", # Name
		24, # Health
		10, # Money
		[ # Units names
			"king",
			"bishop",
		],
		[ # Units offsets
			Vector2i(0, 0),
			Vector2i(1, 0),
		],
		[ # Passives
		]
	)
	role_b = Role.new(
		"Role B", # Name
		20, # Health
		5, # Money
		[ # Units names
			"king",
			"bishop",
		],
		[ # Units offsets
			Vector2i(0, 0),
			Vector2i(1, 0)
		],
		[ # Passives
		]
	)

# Public

# Gets the role parameters given a role enum
func get_role(role_enum: GameManager.RoleEnum) -> Role:
	match role_enum:
		GameManager.RoleEnum.ROLE_A:
			return role_a
		GameManager.RoleEnum.ROLE_B:
			return role_b
	return role_a

# Role parameters
class Role:
	var name: String
	var initial_health: int
	var initial_money: int
	var initial_units_names: Array[String]
	var initial_units_offsets: Array[Vector2i]
	var initial_passives: Array[Skill]
	
	# Constructor
	func _init(
			name: String,
			initial_health: int,
			initial_money: int,
			initial_units_names: Array[String],
			initial_units_offsets: Array[Vector2i],
			initial_passives: Array[Skill]
			) -> void:
		assert(initial_units_names.size() == initial_units_offsets.size(), "role constructor error")
		self.name = name
		self.initial_health = initial_health
		self.initial_money = initial_money
		self.initial_units_names = initial_units_names
		self.initial_units_offsets = initial_units_offsets
		self.initial_passives = initial_passives
		
