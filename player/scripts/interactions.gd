class_name Interactions extends Node2D

@onready var player: Player = $".."
var last_horizontal_direction: Vector2 = Vector2.RIGHT  # Default to right

func _ready():
	player.direction_changed.connect(update_direction)
	
func update_direction(new_direction : Vector2) -> void:
	match new_direction:
		Vector2.LEFT:
			last_horizontal_direction = Vector2.LEFT
			rotation_degrees = 180  # Flip to left side
		Vector2.RIGHT:
			last_horizontal_direction = Vector2.RIGHT
			rotation_degrees = 0    # Default position (right side)
		Vector2.DOWN, Vector2.UP:
			# For up/down movement, keep hitbox on the side based on last horizontal direction
			if last_horizontal_direction == Vector2.LEFT:
				rotation_degrees = 180  # Keep on left side
			else:
				rotation_degrees = 0    # Keep on right side (default)
		_:
			rotation_degrees = 0    # Default fallback
