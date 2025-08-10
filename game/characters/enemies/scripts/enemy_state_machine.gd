# characters/enemies/scripts/enemy_state_machine.gd
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
	
	var chase_state = null
	for state in states:
		if state is EnemyStateChase:
			chase_state = state
			break
	
	# Use chase state as default, otherwise use first state
	var initial_state = chase_state if chase_state else states[0]
	change_state(initial_state)
	process_mode = Node.PROCESS_MODE_INHERIT
