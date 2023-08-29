extends Node2D

@export var player_scene: PackedScene
@onready var players: Node2D = $Players


func _ready() -> void:
	for peer_player in MultiplayerManager.peer_players:
		var player = player_scene.instantiate()
		players.add_child(player)
		player.setup(peer_player)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
