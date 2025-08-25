# gui/scripts/healthbar.gd
class_name HealthBar
extends TextureProgressBar
## Player Character's health bar component
##
## Manages teh health bar sprite for the player character
## Handles setting base values, updating on healing, damage, and max health updates

@export var base_width: float = 192.0
@export var width_per_max_health: float = 1.0
@export var resize_duration: float = 0.5

# Store the player's starting max health to calculate growth
var initial_max_health: int = 0


func _ready() -> void:
	if PlayerManager.player:
		connect_to_player()
	else:
		await get_tree().process_frame
		connect_to_player()


func connect_to_player() -> void:
	var player = PlayerManager.player
	if not player:
		return

	# Store initial values
	initial_max_health = player.max_health
	max_value = player.max_health
	value = player.current_health

	# With anchors, set the offsets to create your base width
	var half_width = base_width / 2.0
	offset_left = -half_width
	offset_right = half_width

	player.damaged.connect(_on_player_damaged)
	player.destroyed.connect(_on_player_destroyed)
	player.healed.connect(_on_player_healed)
	player.max_health_changed.connect(_on_player_max_health_changed)

	update_health_bar()


func resize_health_bar(new_max_health: int) -> void:
	var health_increase = new_max_health - initial_max_health
	var new_width = base_width + (health_increase * width_per_max_health)

	# Animate the offsets to expand equally from center
	var half_width = new_width / 2.0

	var tween = create_tween()
	tween.parallel().tween_property(self, "offset_left", -half_width, resize_duration)
	tween.parallel().tween_property(self, "offset_right", half_width, resize_duration)


func update_health_bar() -> void:
	var player = PlayerManager.player
	if not player:
		return

	# Check if max health changed and resize if needed
	if player.max_health != max_value:
		resize_health_bar(player.max_health)

	max_value = player.max_health
	value = player.current_health


func _on_player_damaged(_hurtbox: Hurtbox) -> void:
	update_health_bar()


func _on_player_destroyed(_hurtbox: Hurtbox) -> void:
	update_health_bar()


func _on_player_healed(_new_health: int) -> void:
	update_health_bar()


func _on_player_max_health_changed(_new_max_health: int) -> void:
	update_health_bar()
