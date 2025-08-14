# characters/player/scripts/player_camera.gd
class_name Camera
extends Camera2D
## Camera that follows the player with level boundary constraints.
##
## Automatically updates its limits based on the current level bounds
## to prevent showing areas outside the tilemap.

func _ready():
	LevelManager.bounds_changed.connect(update_limits)
	update_limits(LevelManager.current_bounds)


func update_limits(bounds: Array[Vector2]) -> void:
	if bounds == []:
		return
	limit_left = int(bounds[0].x)
	limit_top = int(bounds[0].y)
	limit_right = int(bounds[1].x)
	limit_bottom = int(bounds[1].y)