#characters/character.gd
class_name Character extends CharacterBody2D

signal direction_changed(new_direction: Vector2)
signal damaged(damage : int)
signal destroyed()

var cardinal_direction: Vector2 = Vector2.DOWN
var direction: Vector2 = Vector2.ZERO
var invulnerable : bool = false

static var _cached_directions: Array = []
static func get_eight_directions() -> Array:
	if _cached_directions.is_empty():
		_cached_directions = [
			Vector2(0, -1),     # North
			Vector2(1, -1).normalized(),     # Northeast
			Vector2(1, 0),      # East
			Vector2(1, 1).normalized(),      # Southeast
			Vector2(0, 1),      # South
			Vector2(-1, 1).normalized(),     # Southwest
			Vector2(-1, 0),     # West
			Vector2(-1, -1).normalized()     # Northwest
		]
	return _cached_directions

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _physics_process(_delta):
	move_and_slide()

func set_direction(_new_direction: Vector2) -> bool:
	# To be overridden by child classes
	return false

func update_animation(_state: String) -> void:
	# To be overridden by child classes
	pass

func take_damage(damage : int, health: int) -> int:
	if invulnerable:
		return health
	health -= damage
	if health > 0:
		damaged.emit(damage)
	else:
		destroyed.emit()
	return health

# Utility function to convert any vector to nearest 8-direction
func get_nearest_direction(input_dir: Vector2) -> Vector2:
	if input_dir == Vector2.ZERO:
		return Vector2.ZERO
	
	var directions = get_eight_directions()
	var best_direction = directions[0]
	var best_dot = input_dir.dot(directions[0])
	
	for dir in directions:
		var dot_product = input_dir.dot(dir)
		if dot_product > best_dot:
			best_dot = dot_product
			best_direction = dir
	
	return best_direction
