class_name InteractionLabel
extends Control

@export_group("Font Settings")
@export var font: = preload("res://fonts/NorseBold.otf")
@export var font_size: int = 6
@export var font_color: Color = Color.WHITE

@onready var label: Label = $Label


func _ready():
	visible = false
	apply_font_settings()


func apply_font_settings():
	if font:
		label.add_theme_font_override("font", font)

	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", font_color)


func show_prompt(text: String):
	label.text = text
	visible = true


func hide_prompt():
	visible = false


func update_text(text: String):
	label.text = text
