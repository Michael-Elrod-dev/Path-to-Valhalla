# levels/scripts/level.gd
class_name Level
extends Node2D
## Base class for game levels.
##
## Manages enemy spawning, tracks manually placed enemies, and handles
## player positioning. Automatically enables y-sorting and connects to
## the level manager for scene transitions.

@onready var enemy_spawner: EnemySpawner = $EnemySpawner

var manually_placed_enemies: Array[Enemy] = []


func _ready() -> void:
	self.y_sort_enabled = true
	PlayerManager.set_as_parent(self)
	LevelManager.level_load_started.connect(free_level)
	collect_manually_placed_enemies()
	if enemy_spawner:
		enemy_spawner.set_manually_placed_enemies(manually_placed_enemies)


func collect_manually_placed_enemies() -> void:
	manually_placed_enemies.clear()
	_find_enemies_recursive(self)


func free_level() -> void:
	PlayerManager.unparent_player(self)
	queue_free()


func _find_enemies_recursive(node: Node) -> void:
	for child in node.get_children():
		if child is Enemy:
			manually_placed_enemies.append(child)
			child.destroyed.connect(_on_enemy_destroyed)
		else:
			_find_enemies_recursive(child)


func _on_enemy_destroyed(hurtbox: Hurtbox) -> void:
	if enemy_spawner:
		enemy_spawner.on_enemy_destroyed()
