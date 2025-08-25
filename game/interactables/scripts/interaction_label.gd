class_name InteractionLabel
extends Control

@onready var label: Label = $Label


func _ready():
	visible = false


func show_prompt(text: String):
	label.text = text
	visible = true


func hide_prompt():
	visible = false


func update_text(text: String):
	label.text = text
