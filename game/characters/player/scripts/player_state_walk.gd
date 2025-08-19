# characters/player/scripts/player_state_walk.gd
class_name StateWalk
extends PlayerState
## Player walking state for movement.
##
## Handles directional movement at configured speed. Updates walking
## animations based on direction and transitions to idle when stopped
## or attack when attacking.

@export var move_speed: float = 100.0

@onready var idle: State = $"../Idle"
@onready var dash: StateDash = $"../Dash"
@onready var attack: StateAttack = $"../Attack"


func enter() -> void:
	player.idle_walk_sprite.visible = true
	player.attack_sprite.visible = false
	player.update_animation("walk")


func exit() -> void:
	pass


func process(_delta: float) -> State:
	if player.direction == Vector2.ZERO:
		return idle
	player.velocity = player.direction * move_speed
	if player.set_direction():
		player.update_animation("walk")
	
	return null


func physics(_delta: float) -> State:
	return null


func handle_input(event: InputEvent) -> State:
	if event.is_action_pressed("dash"):
		return dash
	if event.is_action_pressed("attack"):
		return attack
	return null
