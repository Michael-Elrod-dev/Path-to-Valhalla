extends Node

const SAVE_PATH = "user://"

signal game_loaded
signal game_saved

var current_save: Dictionary = {
	scene_path = "",
	player = {
		max_health = 1,
		position_x = 0,
		position_y = 0,
		inventory = {}
	}
}

func create_save() -> void:
	update_player_data()
	update_scene_path()
	var file := FileAccess.open(SAVE_PATH + "save.sav", FileAccess.WRITE)
	var save_file = JSON.stringify(current_save)
	file.store_line(save_file)
	game_saved.emit()

func load_save() -> void:
	var file := FileAccess.open(SAVE_PATH + "save.sav", FileAccess.READ)
	var save_file := JSON.new()
	save_file.parse(file.get_line())
	var save_dict: Dictionary = save_file.get_data() as Dictionary
	current_save = save_dict
	load_inventory_data()
	LevelManager.load_new_level(current_save.scene_path)
	await LevelManager.level_load_started
	await LevelManager.level_loaded
	game_loaded.emit()

func update_player_data() -> void:
	var player: Player = PlayerManager.player
	current_save.player.max_health = player.max_health
	current_save.player.position_x = player.global_position.x
	current_save.player.position_y = player.global_position.y
	current_save.player.inventory = PlayerManager.player_resources.duplicate()

func load_inventory_data() -> void:
	if current_save.player.has("inventory"):
		PlayerManager.player_resources = current_save.player.inventory.duplicate()
		for item_id in PlayerManager.player_resources:
			PlayerManager.resource_changed.emit(item_id, PlayerManager.player_resources[item_id])

func update_scene_path() -> void:
	var scene_path: String = ""
	for scene in get_tree().root.get_children():
		if scene is Level:
			scene_path = scene.scene_file_path
	current_save.scene_path = scene_path
