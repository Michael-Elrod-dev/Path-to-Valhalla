extends Node

var current_bounds : Array[Vector2]
signal bounds_changed(bounds : Array[Vector2])

func change_bounds(bounds : Array[Vector2]) -> void:
	current_bounds = bounds
	bounds_changed.emit(bounds)
