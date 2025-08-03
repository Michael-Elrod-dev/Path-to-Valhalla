class_name Plant extends Node2D

func _ready():
	$Hitbox.damaged.connect(take_damage)
	
func take_damage(damage : int) -> void:
	queue_free()
