class_name Interactable
extends Area2D
## Base class for objects the player can interact with

signal interacted(player: Player)

@export var interaction_prompt: String = "Press F to interact"
@export var can_interact: bool = true

var player_in_range: bool = false
var player_reference: Player
var prompt_label: Label


func _ready() -> void:
	# Set up detection signals
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	# Get player reference
	if PlayerManager.player:
		player_reference = PlayerManager.player
	else:
		PlayerManager.player_ready.connect(_on_player_ready)
	
	# Create simple label as child
	create_interaction_label()


func _unhandled_input(event: InputEvent) -> void:
	if player_in_range and can_interact and event.is_action_pressed("interact"):
		interact(player_reference)


func interact(player: Player) -> void:
	if can_interact:
		hide_interaction_prompt()
		interacted.emit(player)
		_on_interact(player)


func show_interaction_prompt() -> void:
	if prompt_label:
		prompt_label.visible = true


func hide_interaction_prompt() -> void:
	if prompt_label:
		prompt_label.visible = false


func set_can_interact(value: bool) -> void:
	can_interact = value
	if not can_interact and player_in_range:
		hide_interaction_prompt()


func create_interaction_label() -> void:
	# Create label directly as child of this object
	prompt_label = Label.new()
	prompt_label.text = interaction_prompt
	prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	prompt_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	# Style the label
	prompt_label.add_theme_font_size_override("font_size", 8)
	prompt_label.add_theme_color_override("font_color", Color.WHITE)
	prompt_label.add_theme_color_override("font_outline_color", Color.BLACK)
	prompt_label.add_theme_constant_override("outline_size", 1)
	
	# Position above the object
	prompt_label.position = Vector2(-40.0, -20.0)
	prompt_label.size = Vector2(80.0, 20.0)
	
	# Add as child so it moves with the object
	add_child(prompt_label)
	prompt_label.visible = false


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


func _on_interact(player: Player) -> void:
	# Override in subclasses
	pass
