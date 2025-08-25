class_name HealthChest
extends Interactable
## Chest that can be opened by the player
##
## Provides the Player with an upgrade to their max health

@export var health_boost: int = 10
@export var is_opened: bool = false


func _ready() -> void:
	super._ready()
	update_interaction_prompt()

	# If already opened, disable interaction
	if is_opened:
		can_interact = false


func open_chest() -> void:
	is_opened = true
	can_interact = false

	# Give max health boost to player
	if PlayerManager.player:
		PlayerManager.player.increase_max_health(health_boost)
		print("Player gained +", health_boost, " max health!")


func _on_interact(_player: Player) -> void:
	if not is_opened:
		open_chest()
