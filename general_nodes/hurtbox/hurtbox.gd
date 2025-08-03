#general_nodes/hurtbox/hurtbox.gd
class_name Hurtbox extends Area2D

@export var damage : int = 1

func _ready():
	area_entered.connect(AreaEntered)
	
func _process(_delta):
	pass

func AreaEntered(area : Area2D) -> void:
	if area is Hitbox:
		area.take_damage(damage)
