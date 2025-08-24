# characters/npcs/scripts/npc.gd
class_name NPC
extends Character
## Non-player character that can engage in dialog conversations.
##
## Extends Character for consistency with game architecture while providing
## dialog interaction capabilities. Supports repeatable conversations.

@export var dialog_data: DialogData
@export var can_repeat_dialog: bool = true
@export var interaction_prompt: String = "Press F to talk"

@onready var sprite: Sprite2D = $Idle
@onready var interaction_area: Area2D = $InteractionArea
@onready var interaction_collision: CollisionShape2D = $InteractionArea/CollisionShape2D

var has_talked: bool = false
var player_in_range: bool = false
var player_reference: Player
var prompt_label: Label


func _ready() -> void:
	super._ready()
	
	# Set up interaction area
	setup_interaction_area()
	
	# Get player reference
	if PlayerManager.player:
		player_reference = PlayerManager.player
	else:
		PlayerManager.player_ready.connect(_on_player_ready)
	
	# Create interaction prompt
	create_interaction_label()
	
	# Start idle animation
	if animation_player:
		update_animation("idle_S")
	
	# Validation
	if not dialog_data:
		push_warning("NPC has no dialog_data assigned!")


func _unhandled_input(event: InputEvent) -> void:
	if player_in_range and can_interact() and event.is_action_pressed("interact"):
		interact()
		get_viewport().set_input_as_handled()


func setup_interaction_area() -> void:
	# Connect signals
	interaction_area.body_entered.connect(_on_interaction_area_entered)
	interaction_area.body_exited.connect(_on_interaction_area_exited)


func can_interact() -> bool:
	if not dialog_data:
		return false
	
	# Check if we can repeat dialog
	if has_talked and not can_repeat_dialog:
		return false
	
	return true


func interact() -> void:
	if not can_interact():
		return
	
	hide_interaction_prompt()
	
	# Start the dialog
	DialogManager.start_dialog(dialog_data)
	has_talked = true
	
	# Connect to dialog end event if not already connected
	if not DialogManager.dialog_ended.is_connected(_on_dialog_ended):
		DialogManager.dialog_ended.connect(_on_dialog_ended)


func show_interaction_prompt() -> void:
	if prompt_label and can_interact():
		prompt_label.visible = true


func hide_interaction_prompt() -> void:
	if prompt_label:
		prompt_label.visible = false


func create_interaction_label() -> void:
	# Create label as child of this NPC
	prompt_label = Label.new()
	prompt_label.text = interaction_prompt
	prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	prompt_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	# Style the label
	prompt_label.add_theme_font_size_override("font_size", 8)
	prompt_label.add_theme_color_override("font_color", Color.WHITE)
	prompt_label.add_theme_color_override("font_outline_color", Color.BLACK)
	prompt_label.add_theme_constant_override("outline_size", 1)
	
	# Position above the NPC
	prompt_label.position = Vector2(-40.0, -40.0)
	prompt_label.size = Vector2(80.0, 20.0)
	
	add_child(prompt_label)
	prompt_label.visible = false


func set_direction(_new_direction: Vector2) -> bool:
	# NPCs don't move, but we implement this for consistency
	return false


func update_animation(state: String) -> void:
	if animation_player:
		animation_player.play(state)


func _on_player_ready(player: Player) -> void:
	player_reference = player


func _on_interaction_area_entered(body: Node2D) -> void:
	if body is Player:
		player_in_range = true
		show_interaction_prompt()


func _on_interaction_area_exited(body: Node2D) -> void:
	if body is Player:
		player_in_range = false
		hide_interaction_prompt()


func _on_dialog_ended() -> void:
	# Show prompt again if dialog can be repeated
	if player_in_range and can_interact():
		show_interaction_prompt()
