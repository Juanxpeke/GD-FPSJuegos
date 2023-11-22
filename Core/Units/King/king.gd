extends Unit
class_name King

func die() -> void:
	super.die()
	get_player().lose_match()
