#globals/player_manager.gd
extends Node

const PLAYER = preload("res://characters/player/player.tscn")
var player: Player
var player_spawned: bool = false

signal player_ready(player_instance: Player)

func _ready() -> void:
	instantiate_player()

func instantiate_player() -> void:
	player = PLAYER.instantiate()
	add_child(player)
	await get_tree().process_frame
	player_ready.emit(player)

func set_player_health(current_health: int, max_health: int) -> void:
	player.max_health = max_health
	player.current_health = current_health
	player.restore_health(0)

func set_player_position(new_position: Vector2) -> void:
	player.global_position = new_position

func set_as_parent(parent: Node2D) -> void:
	if player.get_parent():
		player.get_parent().remove_child(player)
	parent.add_child(player)

func unparent_player(parent: Node2D) -> void:
	parent.remove_child(player)
