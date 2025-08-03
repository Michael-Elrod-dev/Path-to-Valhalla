#characters/enemies/scripts/enemy.gd
class_name Enemy extends Character

@export var Health : int = 3

@onready var sprite: Sprite2D = $Sprite2D
@onready var hitbox: Hitbox = $Hitbox
@onready var enemy_state_machine: EnemyStateMachine = $EnemyStateMachine

var player : Player

# Store directions as a member variable
var direction_8: Array

func _ready() -> void:
	# Initialize the directions array
	direction_8 = get_eight_directions()
	
	enemy_state_machine.initialize(self)
	player = PlayerManager.player
	hitbox.damaged.connect(_on_hitbox_damaged)

func _process(_delta: float) -> void:
	pass

func set_direction(new_direction : Vector2) -> bool:
	direction = new_direction
	if direction == Vector2.ZERO:
		return false
	
	# Convert to one of 8 cardinal directions
	var best_direction = get_nearest_direction(direction)
	
	if best_direction == cardinal_direction:
		return false
	
	cardinal_direction = best_direction
	direction_changed.emit(best_direction)
	
	# Handle sprite flipping for all left-facing directions
	if cardinal_direction.x < 0:  # Any left-facing direction
		sprite.scale.x = -1
	elif cardinal_direction.x > 0:  # Any right-facing direction
		sprite.scale.x = 1
	# For pure up/down (x == 0), keep current facing
	
	return true

func update_animation(state : String) -> void:
	animation_player.play(state + "_" + animation_direction())

func animation_direction() -> String:
	# Map 8 directions to 4 animation directions
	# Pure cardinal directions
	if cardinal_direction.is_equal_approx(Vector2(0, 1)):  # South
		return "down"
	elif cardinal_direction.is_equal_approx(Vector2(0, -1)):  # North
		return "up"
	elif cardinal_direction.is_equal_approx(Vector2(1, 0)) or cardinal_direction.is_equal_approx(Vector2(-1, 0)):  # East or West
		return "side"
	
	# Diagonal directions - check y component for up/down bias
	elif cardinal_direction.y < 0:  # Northeast or Northwest
		return "up"
	elif cardinal_direction.y > 0:  # Southeast or Southwest
		return "down"
	else:
		return "down"  # fallback

func _on_hitbox_damaged(damage : int) -> void:
	Health = take_damage(damage, Health)
