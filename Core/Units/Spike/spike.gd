extends Unit

# self and enemy_unit dies
func be_captured_by(enemy_unit: Unit) -> void:
	enemy_unit.die()
	self.die()
