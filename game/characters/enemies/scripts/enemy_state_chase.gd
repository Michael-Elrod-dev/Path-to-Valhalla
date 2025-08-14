# characters/enemies/scripts/enemy_state_chase.gd
class_name EnemyStateChase
extends EnemyState

@export var animation_name: String = "walk"
@export var chase_speed: float = 40.0
@export var update_direction_interval: float = 0.1

var direction_timer: float = 0.0
var target_direction: Vector2


func initialize() -> void:
	pass


func enter() -> void:
	direction_timer = 0.0
	update_target_direction()
	if target_direction != Vector2.ZERO:
		enemy.set_direction(target_direction)
		enemy.update_animation(animation_name)


func exit() -> void:
	pass


func process(delta: float) -> EnemyState:
	direction_timer -= delta
	
	if direction_timer <= 0.0:
		update_target_direction()
		direction_timer = update_direction_interval
		
		# Update facing direction for animations
		if target_direction != Vector2.ZERO:
			var direction_changed = enemy.set_direction(target_direction)
			# Only update animation if the direction changed
			if direction_changed:
				enemy.update_animation(animation_name)
	
	# Move towards player with free 360-degree movement
	if target_direction != Vector2.ZERO:
		enemy.velocity = target_direction * chase_speed
	else:
		enemy.velocity = Vector2.ZERO
	
	return null


func physics(_delta: float) -> EnemyState:
	return null


func update_target_direction() -> void:
	if enemy.player:
		# Calculate direct direction to player (not constrained to 8 directions)
		target_direction = enemy.global_position.direction_to(enemy.player.global_position)
	else:
		target_direction = Vector2.ZERO
