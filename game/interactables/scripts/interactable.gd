class_name Interactable
extends Area2D
## Base class for objects the player can interact with

signal interacted(player: Player)

const INTERACTION_LABEL_SCENE = preload("res://interactables/interaction_label.tscn")

@export var interaction_prompt: String = "Press F to interact"
@export var label_offset: Vector2 = Vector2(-40.0, -20.0)
@export var can_interact: bool = true

@export_group("Font Settings")
@export var font: = preload("res://fonts/NorseBold.otf")
@export var font_size: int = 6
@export var font_color: Color = Color.WHITE

var player_in_range: bool = false
var player_reference: Player
var prompt_label: InteractionLabel


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

	# Get player reference
	if PlayerManager.player:
		player_reference = PlayerManager.player
	else:
		PlayerManager.player_ready.connect(_on_player_ready)

	# Create simple label as child
	setup_interaction_label()


func _unhandled_input(event: InputEvent) -> void:
	if player_in_range and can_interact and event.is_action_pressed("interact"):
		interact(player_reference)


func interact(player: Player) -> void:
	if can_interact:
		hide_interaction_prompt()
		interacted.emit(player)
		_on_interact(player)


func setup_interaction_label() -> void:
	prompt_label = INTERACTION_LABEL_SCENE.instantiate()
	prompt_label.position = label_offset

	# Apply font settings to the label
	prompt_label.font = font
	prompt_label.font_size = font_size
	prompt_label.font_color = font_color

	add_child(prompt_label)


func show_interaction_prompt() -> void:
	if prompt_label:
		prompt_label.show_prompt(interaction_prompt)


func hide_interaction_prompt() -> void:
	if prompt_label:
		prompt_label.hide_prompt()


func update_interaction_prompt() -> void:
	if prompt_label:
		prompt_label.update_text(interaction_prompt)


func set_can_interact(value: bool) -> void:
	can_interact = value
	if not can_interact and player_in_range:
		hide_interaction_prompt()


func _on_player_ready(player: Player) -> void:
	player_reference = player


func _on_body_entered(body: Node2D) -> void:
	if body is Player and can_interact:
		player_in_range = true
		show_interaction_prompt()


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_range = false
		hide_interaction_prompt()


func _on_interact(_player: Player) -> void:
	# Override in subclasses
	pass
