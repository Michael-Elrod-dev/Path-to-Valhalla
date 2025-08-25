# characters/enemies/scripts/enemy_state_wander.gd
class_name EnemyStateWander
extends EnemyState
## Enemy wandering state for random movement.
##
## Moves in a random direction for a configured duration. Supports
## both 4-directional and 8-directional movement patterns. Transitions
## to next state after completing wander cycles.

@export var animation_name: String = "walk"
@export var walk_speed: float = 20.0

@export_category("AI")
@export var state_animation_duration: float = 0.5
@export var state_cycles_min: int = 1
@export var state_cycles_max: int = 3
@export var next_state: EnemyState
@export var use_diagonal_movement: bool = true

var timer: float = 0.0
var direction: Vector2


func initialize() -> void:
	pass


func enter() -> void:
	timer = randi_range(state_cycles_min, state_cycles_max) * state_animation_duration

	# Choose random direction (4 or 8 directional based on setting)
	if use_diagonal_movement:
		# Pick from all 8 directions
		var rand = randi_range(0, 7)
		direction = enemy.direction_8[rand]
	else:
		# Pick from 4 cardinal directions only
		var cardinal_only = [Vector2(0, -1), Vector2(1, 0), Vector2(0, 1), Vector2(-1, 0)]
		var rand = randi_range(0, 3)
		direction = cardinal_only[rand]

	enemy.velocity = direction * walk_speed
	enemy.set_direction(direction)
	enemy.update_animation(animation_name)


func exit() -> void:
	pass


func process(delta: float) -> EnemyState:
	timer -= delta
	if timer <= 0:
		return next_state
	return null


func physics(_delta: float) -> EnemyState:
	return null
