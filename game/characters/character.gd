#characters/character.gd
class_name Character extends CharacterBody2D

@export var max_health: int = 0

@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal direction_changed(new_direction: Vector2)
signal healed(health: int)
signal damaged(hurtbox: Hurtbox)
signal destroyed(hurtbox: Hurtbox)

var cardinal_direction: Vector2 = Vector2.DOWN
var direction: Vector2 = Vector2.ZERO
var invulnerable : bool = false
var current_health: int = 0

static var cached_directions: Array = []
static func get_eight_directions() -> Array:
	if cached_directions.is_empty():
		cached_directions = [
			Vector2(0, -1),              # North
			Vector2(1, -1).normalized(), # Northeast
			Vector2(1, 0),               # East
			Vector2(1, 1).normalized(),  # Southeast
			Vector2(0, 1),               # South
			Vector2(-1, 1).normalized(), # Southwest
			Vector2(-1, 0),              # West
			Vector2(-1, -1).normalized() # Northwest
		]
	return cached_directions

func _ready() -> void:
	current_health = max_health

func _physics_process(_delta):
	move_and_slide()

func take_damage(hurtbox: Hurtbox) -> void:
	if invulnerable:
		return
	current_health -= hurtbox.damage
	if current_health > 0:
		damaged.emit(hurtbox)
	else:
		destroyed.emit(hurtbox)

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

func set_direction(_new_direction: Vector2) -> bool:
	# To be overridden by child classes
	return false

func update_animation(_state: String) -> void:
	# To be overridden by child classes
	pass
