# levels/scripts/level_transition.gd
@tool
class_name LevelTransition
extends Area2D
## Triggers level transitions when the player enters the area.
##
## Place at level boundaries to load new scenes. Configure the target
## level path and collision area size/side in the inspector. Supports
## snap to grid for easier level design.

enum SIDE { LEFT, RIGHT, TOP, BOTTOM }

@export_file("*.tscn") var level
@export_category("Collision Area Settings")
@export_range(1, 12, 1, "or_greater") var size: int = 1:
	set(value):
		size = value
		_update_area()
@export var side: SIDE = SIDE.LEFT:
	set(value):
		side = value
		_update_area()
@export var snap_to_grid: bool = false:
	set(value):
		snap_to_grid = value
		_snap_to_grid()

@onready var collision_shape: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	_update_area()
	if Engine.is_editor_hint():
		return
	body_entered.connect(player_entered)


func player_entered(_player: Node2D) -> void:
	LevelManager.load_new_level(level)


func _update_area() -> void:
	var new_rect: Vector2 = Vector2(32, 32)
	var new_position: Vector2 = Vector2.ZERO
	
	if side == SIDE.TOP:
		new_rect.x *= size
		new_position.y -= 16
	elif side == SIDE.BOTTOM:
		new_rect.x *= size
		new_position.y += 16
	elif side == SIDE.LEFT:
		new_rect.y *= size
		new_position.x -= 16
	elif side == SIDE.RIGHT:
		new_rect.y *= size
		new_position.x += 16
	
	if collision_shape == null:
		collision_shape = get_node("CollisionShape2D")
		
	collision_shape.shape.size = new_rect
	collision_shape.position = new_position


func _snap_to_grid() -> void:
	position.x = round(position.x / 16.0) * 16.0
	position.y = round(position.y / 16.0) * 16.0
