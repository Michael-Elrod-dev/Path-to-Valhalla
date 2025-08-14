# globals/global_tooltip_manager.gd
extends Node
## Global manager for displaying tooltips in the UI.
##
## Creates and manages a single tooltip instance that can be shown
## at any position with custom title and description text.

var current_tooltip: Tooltip


func _ready() -> void:
	await get_tree().process_frame
	current_tooltip = preload("res://tooltips/tooltip.tscn").instantiate()
	
	var ui_layer = CanvasLayer.new()
	ui_layer.layer = 100
	get_tree().root.add_child(ui_layer)
	ui_layer.add_child(current_tooltip)


func show_tooltip(title: String, description: String) -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	show_tooltip_at_position(title, description, mouse_pos)


func show_tooltip_at_position(title: String, description: String, pos: Vector2) -> void:
	if not current_tooltip:
		return
	current_tooltip.show_tooltip(title, description, pos)


func hide_tooltip() -> void:
	if current_tooltip:
		current_tooltip.hide_tooltip()