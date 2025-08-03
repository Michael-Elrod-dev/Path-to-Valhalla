class_name Hitbox extends Area2D

signal damaged(damage : int)

func _ready():
	pass
	
func _process(delta):
	pass
	
func take_damage(damage : int) -> void:
	print("take_damage: ", damage)
	damaged.emit(damage)
