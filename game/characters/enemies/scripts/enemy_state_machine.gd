#characters/enemies/scripts/enemy_state_machine.gd
class_name EnemyStateMachine extends StateMachine

func initialize(enemy : Enemy) -> void:
	states = []
	
	for child in get_children():
		if child is EnemyState:
			states.append(child)
			
	for s in states:
		s.enemy = enemy
		s.state_machine = self
		s.initialize()
		
	if states.size() == 0:
		return
		
	change_state(states[0])
	process_mode = Node.PROCESS_MODE_INHERIT
