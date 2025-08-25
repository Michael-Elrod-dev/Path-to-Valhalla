# gui/dialog/dialog_box.gd
class_name DialogBox
extends Control
## UI component for displaying dialog text with typing animation.
##
## Shows character name and dialog text that types out character by character.
## Player can click or press F to complete typing or advance to next page.

signal advance_requested

var is_typing: bool = false
var current_text: String = ""
var typing_timer: float = 0.0
var typing_speed: float = 0.005
var visible_characters: int = 0

@onready var character_name_label: Label = $NameLabel
@onready var dialog_label: Label = $DialogLabel
@onready var continue_prompt: Label = $ContinuePrompt


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	continue_prompt.visible = false


func _process(delta: float) -> void:
	if is_typing:
		typing_timer += delta

		if typing_timer >= typing_speed:
			typing_timer = 0.0
			visible_characters += 1

			if visible_characters >= current_text.length():
				complete_text()
			else:
				dialog_label.visible_characters = visible_characters


func show_dialog(character_name: String, text: String, speed: float) -> void:
	character_name_label.text = character_name
	current_text = text
	typing_speed = speed
	dialog_label.text = current_text
	dialog_label.visible_characters = 0
	visible_characters = 0
	typing_timer = 0.0
	continue_prompt.visible = false
	is_typing = true


func complete_text() -> void:
	is_typing = false
	dialog_label.visible_characters = current_text.length()
	continue_prompt.visible = true


func _input(event: InputEvent) -> void:
	if visible and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			advance_requested.emit()
			get_viewport().set_input_as_handled()
