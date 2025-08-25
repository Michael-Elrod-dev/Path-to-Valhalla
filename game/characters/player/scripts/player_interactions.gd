# characters/player/scripts/player_interactions.gd
class_name Interactions
extends Node2D
## Manages the player's interaction direction indicator.
##
## Rotates to match the player's facing direction, useful for
## showing where attacks or interactions will occur.


@onready var player: Player = $".."
@onready var direction_angles = {
	Vector2(0, -1): -90.0,                    # North
	Vector2(1, -1).normalized(): -45.0,       # Northeast
	Vector2(1, 0): 0.0,                       # East
	Vector2(1, 1).normalized(): 45.0,         # Southeast
	Vector2(0, 1): 90.0,                      # South
	Vector2(-1, 1).normalized(): 135.0,       # Southwest
	Vector2(-1, 0): 180.0,                    # West
	Vector2(-1, -1).normalized(): -135.0      # Northwest
}


func _ready():
	player.direction_changed.connect(update_direction)
	update_direction(player.cardinal_direction)


func update_direction(new_direction: Vector2) -> void:
	var angle = get_rotation_for_direction(new_direction)
	rotation_degrees = angle


func get_rotation_for_direction(direction: Vector2) -> float:
	for dir in direction_angles:
		if direction.is_equal_approx(dir):
			return direction_angles[dir]
	return 90.0
