# characters/player/scripts/player_interactions.gd
class_name Interactions extends Node2D

@onready var player: Player = $".."

func _ready():
	player.direction_changed.connect(update_direction)
	update_direction(player.cardinal_direction)
	
func update_direction(new_direction: Vector2) -> void:
	var angle = get_rotation_for_direction(new_direction)
	rotation_degrees = angle

func get_rotation_for_direction(direction: Vector2) -> float:
	# North (UP)
	if direction.is_equal_approx(Vector2(0, -1)):
		return -90.0
	# Northeast
	elif direction.is_equal_approx(Vector2(1, -1).normalized()):
		return -45.0
	# East (RIGHT)
	elif direction.is_equal_approx(Vector2(1, 0)):
		return 0.0
	# Southeast
	elif direction.is_equal_approx(Vector2(1, 1).normalized()):
		return 45.0
	# South (DOWN)
	elif direction.is_equal_approx(Vector2(0, 1)):
		return 90.0
	# Southwest
	elif direction.is_equal_approx(Vector2(-1, 1).normalized()):
		return 135.0
	# West (LEFT)
	elif direction.is_equal_approx(Vector2(-1, 0)):
		return 180.0
	# Northwest
	elif direction.is_equal_approx(Vector2(-1, -1).normalized()):
		return -135.0  # or 225.0, depending on your preference
	else:
		return 90.0  # Default fallback (South, to match player's starting direction)
