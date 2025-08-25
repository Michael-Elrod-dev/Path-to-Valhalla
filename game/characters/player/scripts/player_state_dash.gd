# characters/player/scripts/player_state_dash.gd
class_name StateDash
extends PlayerState
## Player dash state for quick movement bursts.
##
## Provides a short-distance dash in the current movement direction.
## Uses stun animation as placeholder. Disables collision with environment
## and damage during dash. Ready for boundary collision when implemented.

@export var dash_speed: float = 300.0
@export var dash_duration: float = 0.2
@export var decelerate_speed: float = 15.0

var dash_timer: float = 0.0
var dash_direction: Vector2
var is_dashing: bool = false
var original_collision_mask: int
var original_hitbox_monitoring: bool

@onready var idle: State = $"../Idle"
@onready var walk: State = $"../Walk"


func enter() -> void:
	# Use current movement direction, or facing direction if not moving
	if player.direction != Vector2.ZERO:
		dash_direction = player.direction
	else:
		dash_direction = player.cardinal_direction

	# Ensure we have a valid direction
	if dash_direction == Vector2.ZERO:
		dash_direction = Vector2.DOWN

	player.velocity = dash_direction * dash_speed
	player.idle_walk_sprite.visible = true
	player.attack_sprite.visible = false
	player.set_direction(dash_direction)
	player.update_animation("stun")  # Using stun animation as placeholder

	# Store original collision settings
	original_collision_mask = player.collision_mask
	original_hitbox_monitoring = player.hitbox.monitoring

	setup_dash_collision()

	# Start dash timer
	dash_timer = dash_duration
	is_dashing = true


func exit() -> void:
	is_dashing = false
	restore_normal_collision()


func process(delta: float) -> State:
	dash_timer -= delta

	# Apply strong deceleration as dash ends
	if dash_timer <= 0.0:
		is_dashing = false
		player.velocity -= player.velocity * decelerate_speed * delta

		# Transition based on input
		if player.direction == Vector2.ZERO:
			return idle
		return walk

	return null


func physics(_delta: float) -> State:
	return null


func handle_input(_event: InputEvent) -> State:
	return null


func setup_dash_collision() -> void:
	player.collision_mask &= ~(1 << 4)

	# TODO: When boundaries are added, keep them enabled:
	# player.collision_mask |= (1 << boundary_layer_index)  # Keep boundaries

	player.hitbox.monitoring = false
	player.invulnerable = true


func restore_normal_collision() -> void:
	player.collision_mask = original_collision_mask
	player.hitbox.monitoring = original_hitbox_monitoring
	player.invulnerable = false
