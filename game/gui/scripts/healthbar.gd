# gui/scripts/healthbar.gd
class_name HealthBar extends Control

@onready var progress_bar: ProgressBar = $ProgressBar

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
	
	progress_bar.max_value = player.max_health
	progress_bar.value = player.current_health
	player.damaged.connect(_on_player_damaged)
	player.destroyed.connect(_on_player_destroyed)
	player.healed.connect(_on_player_healed)
	update_health_bar()

func _on_player_damaged(_hurtbox: Hurtbox) -> void:
	update_health_bar()

func _on_player_destroyed(_hurtbox: Hurtbox) -> void:
	update_health_bar()

func _on_player_healed(_new_health: int) -> void:
	update_health_bar()

func update_health_bar() -> void:
	var player = PlayerManager.player
	if not player or not progress_bar:
		return
	progress_bar.max_value = player.max_health
	progress_bar.value = player.current_health
	
	var health_percentage = float(player.current_health) / float(player.max_health)
	if health_percentage > 0.66:
		progress_bar.modulate = Color.GREEN
	elif health_percentage > 0.33:
		progress_bar.modulate = Color.YELLOW
	else:
		progress_bar.modulate = Color.RED
