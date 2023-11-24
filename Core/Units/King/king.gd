extends Unit
class_name King

func die() -> void:
	super.die()
	GameManager.board.show_blood_cell(self.get_current_cell())
	get_player().lose_match()
