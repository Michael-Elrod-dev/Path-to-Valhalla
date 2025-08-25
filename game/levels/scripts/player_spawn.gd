# levels/scripts/player_spawn.gd
extends Node2D
## Spawn point marker for the player character.
##
## Place in levels to set the player's starting position. Only
## activates once per game session to prevent respawning.


func _ready() -> void:
	visible = false
	if PlayerManager.player_spawned == false:
		PlayerManager.set_player_position(global_position)
		PlayerManager.player_spawned = true
