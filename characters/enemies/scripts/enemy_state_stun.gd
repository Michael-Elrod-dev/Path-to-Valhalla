#characters/enemies/scripts/enemy_state_stun.gd
class_name EnemyStateStun extends EnemyState

@export var animation_name : String = "stun"
@export var knockback_speed : float = 200.0
@export var decelerate_speed : float = 10.0

@export_category("AI")
@export var next_state : EnemyState

var direction : Vector2
var animation_finished : bool = false

func initialize() -> void:
	enemy.damaged.connect(on_enemy_damaged)

func enter() -> void:
	#enemy.invulnerable = true
	animation_finished = false
	direction = enemy.global_position.direction_to(enemy.player.global_position)
	enemy.set_direction(direction)
	enemy.velocity = direction * -knockback_speed
	enemy.update_animation(animation_name)
	enemy.animation_player.animation_finished.connect(on_animation_finished)

func exit() -> void:
	enemy.invulnerable = false
	enemy.animation_player.animation_finished.disconnect(on_animation_finished)

func process(delta: float) -> EnemyState:
	if animation_finished == true:
		return next_state
	enemy.velocity -= enemy.velocity * decelerate_speed * delta
	return null

func physics(_delta: float) -> EnemyState:
	return null

func on_enemy_damaged(_damage: int) -> void:
	state_machine.change_state(self)

func on_animation_finished(_animation : String) -> void:
	animation_finished = true
