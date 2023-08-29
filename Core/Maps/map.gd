extends Node2D

@export var player_scene: PackedScene

@onready var players: Node2D = %Players
@onready var authority_marker: Marker2D = %AuthorityPosition
@onready var puppet_marker: Marker2D = %PuppetPosition

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	for peer_player in MultiplayerManager.peer_players:
		var player = player_scene.instantiate()
		players.add_child(player)
		
		if multiplayer.get_unique_id() == peer_player.id:
			player.multiplayer_setup(peer_player, authority_marker.position)
		else:
			player.multiplayer_setup(peer_player, puppet_marker.position)
	
# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(delta: float) -> void:
	pass
