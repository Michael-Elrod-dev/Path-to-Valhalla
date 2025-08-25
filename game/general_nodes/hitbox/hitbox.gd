# general_nodes/hitbox/hitbox.gd
class_name Hitbox
extends Area2D
## Area that can receive damage from Hurtbox nodes.
##
## Emits a signal when taking damage. Should be added to entities
## that can be damaged like the player or enemies.

signal damaged(hurtbox: Hurtbox)


func take_damage(hurtbox: Hurtbox) -> void:
	damaged.emit(hurtbox)
