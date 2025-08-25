# characters/player/scripts/player_state_machine.gd
class_name PlayerStateMachine
extends StateMachine
## State machine controller for player states.
##
## Manages state transitions and handles unhandled input events.
## Initializes all child states and sets up shared player reference.


func _unhandled_input(event: InputEvent) -> void:
	change_state(current_state.handle_input(event))


func initialize(player: Player) -> void:
	states = []

	for child in get_children():
		if child is State:
			states.append(child)

	if states.size() == 0:
		return

	PlayerState.player = player
	PlayerState.state_machine = self
	for state in states:
		state.initialize()

	change_state(states[0])
	process_mode = Node.PROCESS_MODE_INHERIT
