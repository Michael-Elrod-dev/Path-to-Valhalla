# characters/enemies/scripts/enemy.gd
class_name Enemy
extends Character
## Base class for enemy characters.
##
## Extends Character with enemy-specific behavior including AI state machine,
## sprite flipping based on direction, and automatic player targeting.
## Handles damage and destruction through connected hitbox.

var player: Player
var direction_8: Array

@onready var sprite: Sprite2D = $Sprite2D
@onready var hitbox: Hitbox = $Hitbox
@onready var enemy_state_machine: EnemyStateMachine = $EnemyStateMachine


func _ready() -> void:
	super._ready()
	direction_8 = get_eight_directions()
	enemy_state_machine.initialize(self)
	if PlayerManager.player:
		player = PlayerManager.player
	hitbox.damaged.connect(_on_hitbox_damaged)


func _process(_delta: float) -> void:
	pass


func set_direction(new_direction: Vector2) -> bool:
	direction = new_direction
	if direction == Vector2.ZERO:
		return false

	# For animation purposes, snap to nearest 8-direction
	var best_direction = get_nearest_direction(direction)
	if best_direction == cardinal_direction:
		return false

	cardinal_direction = best_direction
	direction_changed.emit(best_direction)

	# Update sprite facing
	if cardinal_direction.x < 0:  # Any left-facing direction
		sprite.scale.x = -1
	elif cardinal_direction.x > 0:  # Any right-facing direction
		sprite.scale.x = 1
	# For pure up/down (x == 0), keep current facing
	return true


func update_animation(state: String) -> void:
	animation_player.play(state + "_" + animation_direction())


func animation_direction() -> String:
	var result = ""
	var down = Vector2(0, 1)
	var up = Vector2(0, -1)
	var left = Vector2(1, 0)
	var right = Vector2(-1, 0)

	if cardinal_direction.is_equal_approx(down):
		result = "down"
	elif cardinal_direction.is_equal_approx(up):
		result = "up"
	elif (cardinal_direction.is_equal_approx(left) or cardinal_direction.is_equal_approx(right)):
		result = "side"
	elif cardinal_direction.y < 0:
		result = "up"
	elif cardinal_direction.y > 0:
		result = "down"
	else:
		result = "down"
	return result


func _on_hitbox_damaged(hurtbox: Hurtbox) -> void:
	take_damage(hurtbox)
