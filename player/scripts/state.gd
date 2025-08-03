class_name State extends Node

static var player: Player

func enter() -> void:
	pass

func exit() -> void:
	pass
	
	
func process(delta: float) -> State:
	return null
	
func physics(delta: float) -> State:
	return null
	
func handle_input(event: InputEvent) -> State:
	return null
