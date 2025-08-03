#general_nodes/hitbox/hitbox.gd
class_name Hitbox extends Area2D

signal damaged(damage : int)

func take_damage(damage : int) -> void:
	damaged.emit(damage)
