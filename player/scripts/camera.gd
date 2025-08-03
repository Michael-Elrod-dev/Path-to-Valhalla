class_name Camera extends Camera2D

func _ready():
	LevelManager.bounds_changed.connect(update_limits)
	update_limits(LevelManager.current_bounds)
	
func update_limits(bounds : Array[Vector2]) -> void:
	if bounds == []:
		print("No bounds received!")
		return
	print("Setting camera limits: ", bounds)
	limit_left = int(bounds[0].x)
	limit_top = int(bounds[0].y)
	limit_right = int(bounds[1].x)
	limit_bottom = int(bounds[1].y)
	print("Camera limits set - Left:", limit_left, "Top:", limit_top, "Right:", limit_right, "Bottom:", limit_bottom)
