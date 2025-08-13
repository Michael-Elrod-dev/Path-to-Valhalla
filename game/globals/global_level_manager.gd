# globals/global_level_manager.gd
extends Node

signal level_load_started
signal level_loaded
signal bounds_changed(bounds: Array[Vector2])

var current_bounds: Array[Vector2]


func _ready() -> void:
	await get_tree().process_frame
	level_loaded.emit()


func change_bounds(bounds: Array[Vector2]) -> void:
	current_bounds = bounds
	bounds_changed.emit(bounds)


func load_new_level(level_path: String) -> void:
	get_tree().paused = true
	level_load_started.emit()
	PlayerManager.player_spawned = false
	await SceneTransition.fade_out()
	get_tree().change_scene_to_file(level_path)
	get_tree().paused = false
	await SceneTransition.fade_in()
	level_loaded.emit()