# general_nodes/state_machines/state_machine.gd
class_name StateMachine
extends Node
## Generic state machine for managing state transitions.
##
## Handles state changes and delegates process/physics updates to
## the current state. Tracks current and previous states.

var states: Array[State]
var previous_state: State
var current_state: State


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED


func _process(delta: float) -> void:
	change_state(current_state.process(delta))


func _physics_process(delta: float) -> void:
	change_state(current_state.physics(delta))


func change_state(new_state: State) -> void:
	if new_state == null:
		return
	if new_state == current_state:
		return
	if current_state:
		current_state.exit()
	
	previous_state = current_state
	current_state = new_state
	current_state.enter()