# tooltips/scripts/tooltip.gd
class_name Tooltip
extends Control

@export_group("Layout")
@export var tooltip_width: int = 200
@export var offset_from_mouse: Vector2 = Vector2(10, 10)

@export_group("Fonts")
@export var title_font: Font
@export var title_font_size: int = 16
@export var title_color: Color = Color.WHITE
@export var desc_font: Font
@export var desc_font_size: int = 14
@export var desc_color: Color = Color(0.9, 0.9, 0.9)

@onready var title_label: Label = $Background/Content/Title
@onready var desc_label: Label = $Background/Content/Description
@onready var background: Control = $Background


func _ready() -> void:
	visible = false
	call_deferred("setup_tooltip")


func setup_tooltip() -> void:
	custom_minimum_size.x = tooltip_width
	size.x = tooltip_width
	if desc_label:
		desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		desc_label.custom_minimum_size.x = tooltip_width - 20
	if title_label:
		if title_font:
			title_label.add_theme_font_override("font", title_font)
		title_label.add_theme_font_size_override("font_size", title_font_size)
		title_label.add_theme_color_override("font_color", title_color)
	if desc_label:
		if desc_font:
			desc_label.add_theme_font_override("font", desc_font)
		desc_label.add_theme_font_size_override("font_size", desc_font_size)
		desc_label.add_theme_color_override("font_color", desc_color)


func show_tooltip(title: String, description: String, mouse_pos: Vector2) -> void:
	title_label.text = title
	desc_label.text = description
	await get_tree().process_frame
	global_position = mouse_pos + offset_from_mouse
	visible = true


func hide_tooltip() -> void:
	visible = false