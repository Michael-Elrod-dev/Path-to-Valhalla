# globals/global_resource_manager.gd
extends Node
## Loads and manages all game resource definitions.
##
## Automatically loads all ResourceData files from the resources folder
## on startup. Provides access to resource data by ID for tooltips,
## displays, and game logic.

var resource_definitions: Dictionary = {}
var resource_directory: String = "res://resources/"


func _ready() -> void:
	load_all_resources()


func load_all_resources() -> void:
	var dir = DirAccess.open(resource_directory)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		if file_name.ends_with(".tres"):
			var full_path = resource_directory + file_name
			var resource_data = load(full_path) as ResourceData
			if resource_data is ResourceData:
				resource_definitions[resource_data.resource_id] = resource_data
		file_name = dir.get_next()
	dir.list_dir_end()


func get_resource_data(resource_id: String) -> ResourceData:
	return resource_definitions.get(resource_id, null)


func get_all_resource_ids() -> Array[String]:
	var result: Array[String] = []
	for key in resource_definitions.keys():
		result.append(key as String)
	return result
