class_name Level extends Node2D


func _ready() -> void:
	self.y_sort_enabled = true
	PlayerManager.set_as_parent(self)
	LevelManager.level_load_started.connect(free_level)
	print("Level loaded - Tree paused: ", get_tree().paused)
	print("PauseMenu visible: ", get_node("/root/PauseMenu").visible if has_node("/root/PauseMenu") else "No PauseMenu")
	get_viewport().gui_disable_input = false
	print("Viewport input disabled: ", get_viewport().gui_disable_input)
	print("Active nodes in tree: ", get_tree().get_node_count())

func free_level() -> void:
	PlayerManager.unparent_player(self)
	queue_free()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		print("Level received mouse click at: ", event.position)
	if event is InputEventMouseMotion:
		print("Level received mouse motion at: ", event.position)
