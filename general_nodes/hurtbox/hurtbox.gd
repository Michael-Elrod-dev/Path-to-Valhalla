#general_nodes/hurtbox/hurtbox.gd
class_name Hurtbox extends Area2D

@export var damage : int = 1

func _ready():
	area_entered.connect(_area_entered)
	
func _process(_delta):
	pass

func _area_entered(area : Area2D) -> void:
	if area is Hitbox and area.owner != owner:
		area.take_damage(self)
