# characters/enemies/scripts/enemy_state_idle.gd
class_name EnemyStateIdle
extends EnemyState

@export var animation_name: String = "idle"

@export_category("AI")
@export var state_duration_min: float = 0.5
@export var state_duration_max: float = 1.5
@export var next_state: EnemyState

var timer: float = 0.0


func initialize() -> void:
	pass
	

func enter() -> void:
	enemy.velocity = Vector2.ZERO
	timer = randf_range(state_duration_min, state_duration_max)
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