#characters/player/scripts/player_state_machine.gd
class_name PlayerStateMachine extends StateMachine

func _unhandled_input(event: InputEvent) -> void:
	change_state(current_state.handle_input(event))

func initialize(player : Player) -> void:
	states = []
	
	for child in get_children():
		if child is State:
			states.append(child)
			
	if states.size() > 0:
		states[0].player = player
		change_state(states[0])
		process_mode = Node.PROCESS_MODE_INHERIT
