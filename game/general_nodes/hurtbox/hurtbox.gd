# general_nodes/hurtbox/hurtbox.gd
class_name Hurtbox
extends Area2D
## Area that deals damage to Hitbox nodes.
##
## Automatically damages any Hitbox it overlaps with that belongs
## to a different owner. Configure damage amount in the inspector.

@export var damage: int = 25


func _ready():
	area_entered.connect(_area_entered)


func _process(_delta):
	pass


func _area_entered(area: Area2D) -> void:
	if area is Hitbox and area.owner != owner:
		area.take_damage(self)
