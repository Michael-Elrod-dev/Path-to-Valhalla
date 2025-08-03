#characters/player/scripts/player.gd
class_name Player extends Character

@onready var state_machine: PlayerStateMachine = $StateMachine
@onready var idle_walk_sprite: Sprite2D = $Idle_Walk
@onready var attack_sprite: Sprite2D = $Attack

func _ready() -> void:
	PlayerManager.player = self
	state_machine.initialize(self)
	
func _process(_delta: float) -> void:
	direction = Vector2(
		Input.get_axis("move_left", "move_right"), 
		Input.get_axis("move_up", "move_down")
		).normalized()

func set_direction(_new_direction: Vector2 = Vector2.ZERO) -> bool:
	# If no parameter passed, use the instance direction
	var dir_to_set = _new_direction if _new_direction != Vector2.ZERO else direction
	
	if dir_to_set == Vector2.ZERO:
		return false
	
	var new_direction: Vector2 = get_direction(dir_to_set)
	
	if new_direction == cardinal_direction:
		return false
		
	cardinal_direction = new_direction
	direction_changed.emit(new_direction)
	
	return true

# Convert input direction to one of 8 cardinal directions
func get_direction(input_dir: Vector2) -> Vector2:
	# Define the 8 directions with their angles
	var directions = [
		Vector2(0, -1),    # North (UP)
		Vector2(1, -1).normalized(),    # Northeast
		Vector2(1, 0),     # East (RIGHT)
		Vector2(1, 1).normalized(),     # Southeast
		Vector2(0, 1),     # South (DOWN)
		Vector2(-1, 1).normalized(),    # Southwest
		Vector2(-1, 0),    # West (LEFT)
		Vector2(-1, -1).normalized()    # Northwest
	]
	
	var best_direction = directions[0]
	var best_dot = input_dir.dot(directions[0])
	
	for dir in directions:
		var dot_product = input_dir.dot(dir)
		if dot_product > best_dot:
			best_dot = dot_product
			best_direction = dir
	
	return best_direction

func update_animation(state: String):
	animation_player.play(state + "_" + convert_direction())
	
func convert_direction() -> String:
	# Convert Vector2 direction to animation suffix
	if cardinal_direction.is_equal_approx(Vector2(0, -1)):  # North
		return "N"
	elif cardinal_direction.is_equal_approx(Vector2(1, -1).normalized()):  # Northeast
		return "NE"
	elif cardinal_direction.is_equal_approx(Vector2(1, 0)):  # East
		return "E"
	elif cardinal_direction.is_equal_approx(Vector2(1, 1).normalized()):  # Southeast
		return "SE"
	elif cardinal_direction.is_equal_approx(Vector2(0, 1)):  # South
		return "S"
	elif cardinal_direction.is_equal_approx(Vector2(-1, 1).normalized()):  # Southwest
		return "SW"
	elif cardinal_direction.is_equal_approx(Vector2(-1, 0)):  # West
		return "W"
	elif cardinal_direction.is_equal_approx(Vector2(-1, -1).normalized()):  # Northwest
		return "NW"
	else:
		return "S"  # Default fallback
