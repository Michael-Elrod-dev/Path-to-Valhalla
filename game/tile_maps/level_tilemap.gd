# tile_maps/level_tilemap.gd
extends Node2D


func _ready():
	call_deferred("calculate_bounds")


func calculate_bounds():
	var all_bounds = get_combined_bounds()
	LevelManager.change_bounds(all_bounds)


func get_combined_bounds() -> Array[Vector2]:
	var min_pos = Vector2i(2_147_483_647, 2_147_483_647)
	var max_pos = Vector2i(-2_147_483_648, -2_147_483_648)
	var found_tiles = false
	var tile_size = Vector2i(32, 32)
	
	for child in get_children():
		if child is TileMapLayer:
			var layer = child as TileMapLayer
			
			if layer.tile_set != null and not found_tiles:
				tile_size = layer.tile_set.tile_size
			
			var used_cells = layer.get_used_cells()
			if not used_cells.is_empty():
				found_tiles = true
				
				for cell in used_cells:
					min_pos.x = min(min_pos.x, cell.x)
					min_pos.y = min(min_pos.y, cell.y)
					max_pos.x = max(max_pos.x, cell.x)
					max_pos.y = max(max_pos.y, cell.y)
	
	if not found_tiles:
		return []
	
	var bounds: Array[Vector2] = []
	bounds.append(Vector2(min_pos * tile_size))
	bounds.append(Vector2((max_pos + Vector2i.ONE) * tile_size))
	
	return bounds