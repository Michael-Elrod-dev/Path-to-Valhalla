# gui/pause_menu/pause_menu.gd
extends CanvasLayer
## In-game pause menu with save/load functionality.
##
## Pauses the game tree when activated with the pause action.
## Provides options to save the current game state or load a previous save.

@onready var vbox_container: VBoxContainer = $VBoxContainer
@onready var button_save: Button = $VBoxContainer/button_save
@onready var button_load: Button = $VBoxContainer/button_load

var is_paused: bool = false


func _ready() -> void:
	unpause_game()
	button_save.pressed.connect(on_save)
	button_load.pressed.connect(on_load)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if is_paused == false:
			pause_game()
		else:
			unpause_game()
		get_viewport().set_input_as_handled()


func pause_game() -> void:
	get_tree().paused = true
	visible = true
	is_paused = true
	button_save.grab_focus()
	if vbox_container:
		vbox_container.mouse_filter = Control.MOUSE_FILTER_STOP


func unpause_game() -> void:
	get_tree().paused = false
	visible = false
	is_paused = false
	if vbox_container:
		vbox_container.mouse_filter = Control.MOUSE_FILTER_IGNORE


func on_save() -> void:
	if is_paused == false:
		return
	SaveManager.create_save()
	unpause_game()


func on_load() -> void:
	if is_paused == false:
		return
	unpause_game()
	SaveManager.load_save()
	await LevelManager.level_load_started