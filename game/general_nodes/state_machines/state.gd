# general_nodes/state_machines/state.gd
class_name State
extends Node
## Base class for state machine states.
##
## Provides virtual methods for state lifecycle (enter/exit) and
## update loops (process/physics). Subclasses should override these
## methods to implement specific state behavior.


func initialize() -> void:
	pass


func enter() -> void:
	pass


func exit() -> void:
	pass


func process(_delta: float) -> State:
	return null


func physics(_delta: float) -> State:
	return null


func handle_input(_event: InputEvent) -> State:
	return null
