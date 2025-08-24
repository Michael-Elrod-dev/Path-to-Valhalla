# globals/global_dialog_manager.gd
extends Node
## Global manager for the dialog system.
##
## Handles dialog state, text typing animations, and coordinates between
## NPCs and the dialog UI. Manages game pausing during conversations.

signal dialog_started
signal dialog_ended

var dialog_box_scene = preload("res://gui/dialog/dialog_box.tscn")
var current_dialog_box: DialogBox
var current_dialog_data: DialogData
var current_page: int = 0
var is_dialog_active: bool = false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func start_dialog(dialog_data: DialogData) -> void:
	if is_dialog_active:
		return
	
	current_dialog_data = dialog_data
	current_page = 0
	is_dialog_active = true
	
	pause_game()
	create_dialog_box()
	show_current_page()
	
	dialog_started.emit()


func end_dialog() -> void:
	if not is_dialog_active:
		return
	
	is_dialog_active = false
	
	# Clean up dialog box
	if current_dialog_box:
		current_dialog_box.queue_free()
		current_dialog_box = null
	
	unpause_game()
	
	# Clear current data
	current_dialog_data = null
	current_page = 0
	
	dialog_ended.emit()


func advance_dialog() -> void:
	if not is_dialog_active or not current_dialog_data:
		return
	
	# If text is still typing, complete it instantly
	if current_dialog_box and current_dialog_box.is_typing:
		current_dialog_box.complete_text()
		return
	
	# If we have more pages, show next page
	if current_page < current_dialog_data.dialog_pages.size() - 1:
		current_page += 1
		show_current_page()
	else:
		# We're at the end - close dialog
		end_dialog()


func create_dialog_box() -> void:
	current_dialog_box = dialog_box_scene.instantiate()
	
	# Add to scene tree at high layer
	var ui_layer = CanvasLayer.new()
	ui_layer.layer = 50
	get_tree().root.add_child(ui_layer)
	ui_layer.add_child(current_dialog_box)
	
	# Connect signal
	current_dialog_box.advance_requested.connect(advance_dialog)


func show_current_page() -> void:
	if not current_dialog_box or not current_dialog_data:
		return
	
	var page_text = current_dialog_data.dialog_pages[current_page]
	var character_name = current_dialog_data.character_name
	var typing_speed = current_dialog_data.dialog_speed
	
	current_dialog_box.show_dialog(character_name, page_text, typing_speed)


func pause_game() -> void:
	get_tree().paused = true


func unpause_game() -> void:
	get_tree().paused = false
