#globals/player_manager.gd
extends Node

const PLAYER = preload("res://characters/player/player.tscn")
var player: Player
var player_spawned: bool = false

func _ready() -> void:
	instantiate_player()

func instantiate_player() -> void:
	player = PLAYER.instantiate()
	add_child(player)

func set_player_position(new_position: Vector2) -> void:
	player.global_position = new_position

func set_as_parent(parent: Node2D) -> void:
	if player.get_parent():
		player.get_parent().remove_child(player)
	parent.add_child(player)

func unparent_player(parent: Node2D) -> void:
	parent.remove_child(player)
