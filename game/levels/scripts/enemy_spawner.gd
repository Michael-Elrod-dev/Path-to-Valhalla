# levels/scripts/enemy_spawner.gd
class_name EnemySpawner
extends Node2D

@export_category("Spawn Settings")
@export var enemy_scenes: Array[PackedScene] = []
@export var total_enemies: int = 20
@export var max_enemies_alive: int = 8
@export var spawn_rate: float = 2.0
@export var spawn_distance: float = 400.0

var enemies_spawned: int = 0
var current_enemies_alive: int = 0
var manually_placed_count: int = 0
var spawn_timer: Timer

var camera: Camera2D
var level_bounds: Array[Vector2]


func _ready() -> void:
	# Create spawn timer
	spawn_timer = Timer.new()
	spawn_timer.wait_time = spawn_rate
	spawn_timer.timeout.connect(_try_spawn_enemy)
	spawn_timer.autostart = false
	add_child(spawn_timer)
	
	# Wait for camera and level bounds
	await get_tree().process_frame
	_find_camera()
	LevelManager.bounds_changed.connect(_on_bounds_changed)


func setup_spawning(total: int, max_alive: int, rate: float, distance: float) -> void:
	total_enemies = total
	max_enemies_alive = max_alive
	spawn_rate = rate
	spawn_distance = distance
	
	if spawn_timer:
		spawn_timer.wait_time = spawn_rate


func set_manually_placed_enemies(enemies: Array[Enemy]) -> void:
	manually_placed_count = enemies.size()
	current_enemies_alive = manually_placed_count
	enemies_spawned = manually_placed_count
	
	# Start spawning if we haven't reached limits
	if should_continue_spawning():
		spawn_timer.start()


func should_continue_spawning() -> bool:
	return (enemies_spawned < total_enemies 
			and current_enemies_alive < max_enemies_alive)


func _find_camera() -> void:
	# Look for camera in PlayerManager.player first
	if PlayerManager.player and PlayerManager.player.get_viewport():
		camera = PlayerManager.player.get_viewport().get_camera_2d()
	
	# Fallback: search the scene tree
	if not camera:
		camera = _find_camera_recursive(get_tree().root)


func _find_camera_recursive(node: Node) -> Camera2D:
	if node is Camera2D:
		return node
	for child in node.get_children():
		var result = _find_camera_recursive(child)
		if result:
			return result
	return null


func _on_bounds_changed(bounds: Array[Vector2]) -> void:
	level_bounds = bounds


func _try_spawn_enemy() -> void:
	if not should_continue_spawning():
		spawn_timer.stop()
		return
	
	if not camera or enemy_scenes.is_empty():
		return
	
	var spawn_position = _get_spawn_position()
	if spawn_position != Vector2.ZERO:
		_spawn_enemy_at_position(spawn_position)


func _get_spawn_position() -> Vector2:
	if not camera:
		return Vector2.ZERO
	
	var camera_pos = camera.global_position
	var viewport_size = get_viewport().get_visible_rect().size
	var camera_zoom = camera.zoom if camera.zoom != Vector2.ZERO else Vector2.ONE
	
	# Calculate actual screen size considering zoom
	var screen_size = viewport_size / camera_zoom
	
	# Try multiple attempts to find a valid spawn position
	for i in range(20):  # Max 20 attempts
		var spawn_pos = _generate_random_spawn_position(camera_pos, screen_size)
		
		# Check if position is within level bounds
		if _is_position_in_bounds(spawn_pos):
			return spawn_pos
	
	return Vector2.ZERO


func _generate_random_spawn_position(camera_pos: Vector2, screen_size: Vector2) -> Vector2:
	# Generate position outside camera view but within spawn distance
	var angle = randf() * TAU  # Random angle
	var distance = spawn_distance + randf() * 100.0  # Some variation in distance
	
	# Calculate position
	var offset = Vector2(cos(angle), sin(angle)) * distance
	return camera_pos + offset


func _is_position_in_bounds(pos: Vector2) -> bool:
	if level_bounds.size() < 2:
		return true  # No bounds set, allow anywhere
	
	var min_bounds = level_bounds[0]
	var max_bounds = level_bounds[1]
	
	return (pos.x >= min_bounds.x and pos.x <= max_bounds.x
			and pos.y >= min_bounds.y and pos.y <= max_bounds.y)


func _spawn_enemy_at_position(spawn_pos: Vector2) -> void:
	# Pick random enemy scene
	var enemy_scene = enemy_scenes[randi() % enemy_scenes.size()]
	var enemy = enemy_scene.instantiate()
	
	if enemy is Enemy:
		# Add to level (parent of this spawner)
		get_parent().add_child(enemy)
		enemy.global_position = spawn_pos
		
		# Connect to destruction signal
		enemy.destroyed.connect(_on_spawned_enemy_destroyed)
		
		# Update counters
		enemies_spawned += 1
		current_enemies_alive += 1
		
		# Continue spawning if needed
		if should_continue_spawning() and not spawn_timer.is_stopped():
			pass  # Timer will continue
		else:
			spawn_timer.stop()


func _on_spawned_enemy_destroyed(_hurtbox: Hurtbox) -> void:
	current_enemies_alive -= 1
	
	# Resume spawning if we were at the limit
	if should_continue_spawning() and spawn_timer.is_stopped():
		spawn_timer.start()


func on_enemy_destroyed() -> void:
	# Called from level when any enemy (manual or spawned) is destroyed
	current_enemies_alive = max(0, current_enemies_alive - 1)
	
	# Resume spawning if we were at the limit
	if should_continue_spawning() and spawn_timer.is_stopped():
		spawn_timer.start()