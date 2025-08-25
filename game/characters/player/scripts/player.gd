# characters/player/scripts/player.gd
class_name Player
extends Character
## Main player character controller.
##
## Handles player input, animations, state management, and health.
## Uses a state machine for different actions like idle, walk, and attack.
## Manages both 8-directional movement and sprite animations.

signal max_health_changed(new_max_health: int)

@onready var effect_animation_player: AnimationPlayer = $EffectAnimationPlayer
@onready var state_machine: PlayerStateMachine = $StateMachine
@onready var idle_walk_sprite: Sprite2D = $Idle_Walk
@onready var attack_sprite: Sprite2D = $Attack
@onready var hitbox: Hitbox = $Hitbox
@onready var direction_strings = {
	Vector2(0, -1): "N",                    # North
	Vector2(1, -1).normalized(): "NE",      # Northeast
	Vector2(1, 0): "E",                     # East
	Vector2(1, 1).normalized(): "SE",       # Southeast
	Vector2(0, 1): "S",                     # South
	Vector2(-1, 1).normalized(): "SW",      # Southwest
	Vector2(-1, 0): "W",                    # West
	Vector2(-1, -1).normalized(): "NW"      # Northwest
}


func _ready() -> void:
	super._ready()
	PlayerManager.player = self
	state_machine.initialize(self)
	hitbox.damaged.connect(_on_hitbox_damaged)
	destroyed.connect(_on_player_destroyed)
	restore_health(99)


func _unhandled_input(_event: InputEvent) -> void:
	# Only update when input changes
	var new_direction = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	).normalized()

	if new_direction != direction:
		direction = new_direction.normalized()


func set_direction(_new_direction: Vector2 = Vector2.ZERO) -> bool:
	var dir_to_set = _new_direction if _new_direction != Vector2.ZERO else direction
	if dir_to_set == Vector2.ZERO:
		return false

	var new_direction: Vector2 = get_nearest_direction(dir_to_set)
	if new_direction == cardinal_direction:
		return false

	cardinal_direction = new_direction
	direction_changed.emit(new_direction)
	return true


func update_animation(state: String):
	animation_player.play(state + "_" + convert_direction())


func convert_direction() -> String:
	for dir in direction_strings:
		if cardinal_direction.is_equal_approx(dir):
			return direction_strings[dir]
	return "S"


func restore_health(heal_amount: int) -> void:
	current_health = clampi(current_health + heal_amount, 0, max_health)
	healed.emit(heal_amount)


func make_invulnerable(duration: float) -> void:
	invulnerable = true
	hitbox.monitoring = false
	await get_tree().create_timer(duration).timeout
	invulnerable = false
	hitbox.monitoring = true


func _on_hitbox_damaged(hurtbox: Hurtbox) -> void:
	take_damage(hurtbox)


func increase_max_health(amount: int) -> void:
	var old_max_health = max_health
	max_health += amount

	current_health += amount
	current_health = clampi(current_health, 0, max_health)

	max_health_changed.emit(max_health)
	print("Max health increased from ", old_max_health, " to ", max_health)


func _on_player_destroyed(_hurtbox: Hurtbox) -> void:
	restore_health(999)
