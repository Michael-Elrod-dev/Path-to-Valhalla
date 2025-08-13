# general_nodes/hitbox/hitbox.gd
class_name Hitbox
extends Area2D

signal damaged(hurtbox: Hurtbox)


func take_damage(hurtbox: Hurtbox) -> void:
	damaged.emit(hurtbox)