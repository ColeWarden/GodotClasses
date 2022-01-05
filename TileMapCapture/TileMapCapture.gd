extends Node2D

# Exports a texture of all tiles within (tilemap_node_paths)
# from (Begin.global_position to End.global_position).
# Saves texture under (export_path).png.

# (tile_edges_only):
# 	True: texture will skip all surrounded tiles.
# 	False: texture will read all tiles.

# (surrounded_tile_auto_coord):
#	Sets the surrounded tile within the tileset.

# (snap_begin_and_end)
#	Snaps begin and end's global_positions to tilemap_size

# Note: 
#	-Doesn't work with multiple tilemaps of different tile sizes
#	-First index in the tilemap_node_paths is drawn first, last draws last
#	-Tilemaps's alpha channel is ignored.

export(Array) var tilemap_node_paths: Array = []
export(Vector2) var tilemap_size: Vector2 = Vector2(32,32)
export(String) var export_path: String = "export_capture_"
export(bool) var tile_edges_only: bool = true
export(Vector2) var surrounded_tile_auto_coord: Vector2 = Vector2(1,1)
export(bool) var snap_begin_and_end: bool = true


func export_tilemap_capture() -> void:
	if tilemap_node_paths.empty():
		return
	
	# Get tilemap nodes from nodepaths provided
	var tilemaps: Array = []
	for path in tilemap_node_paths:
		if path:
			var tilemap = get_node(path)
			if (tilemap) and (tilemap is TileMap):
				tilemaps.append(tilemap)
	
	# Get bounding box for size of new image
	var begin: Position2D = $Begin
	var end: Position2D = $End
	var begin_pos: Vector2 = begin.global_position
	var end_pos: Vector2 = end.global_position
	if snap_begin_and_end:
		begin_pos = begin_pos.snapped(tilemap_size)
		end_pos = end_pos.snapped(tilemap_size)
	var final_image_size: Vector2 = end_pos - begin_pos
	final_image_size = Vector2(abs(final_image_size.x), abs(final_image_size.y))
	
	# Get tiles to read in
	var tile_capture_size: Vector2 = final_image_size / 32
	var tiles: PoolVector2Array = []
	for tile_x in tile_capture_size.x:
		for tile_y in tile_capture_size.y:
			var tile_pos: Vector2 = Vector2(tile_x, tile_y)
			tiles.append(tile_pos)
	
	# Ready the final image
	var final_image: Image = Image.new()
	var image_width: int = int(final_image_size.x)
	var image_height: int = int(final_image_size.y)
	final_image.create(image_width, image_height, false, Image.FORMAT_RGBA8)
	
	
	var world_position = begin_pos / 32.0
	
	# IF tile exists, get texture and autocoord to copy to final image
	for tile_pos in tiles:
		var world_tile_pos: Vector2 = tile_pos + world_position
		
		# Iterate throught all tilemaps and check for tile
		for tilemap in tilemaps:
			
			# Check for if tile id exists in tilemap
			var id: int = tilemap.get_cellv(world_tile_pos)
			if id == -1:
				continue
			
			# Get autocoord and get image of tile on tileset texture
			var auto_coord: Vector2 = tilemap.get_cell_autotile_coord(world_tile_pos.x, world_tile_pos.y)
			if tile_edges_only:
				if auto_coord == surrounded_tile_auto_coord:
					continue
			
			var tileset_texture: Texture = tilemap.tile_set.tile_get_texture(id)
			if tileset_texture == null:
				continue
			auto_coord *= 32
			
			# Get tile texture from tileset texture and copy
			var tile_image: Image = tileset_texture.get_data()
			var tile_rect: Rect2 = Rect2(auto_coord.x, auto_coord.y, tilemap_size.x, tilemap_size.y)
			final_image.blend_rect(tile_image, tile_rect, tile_pos*32)
	
	# Create texture from image 
	var export_texture: ImageTexture = ImageTexture.new()
	export_texture.create_from_image(final_image)
	
	# Save to path that isn't taken 
	var file: File = File.new()
	var index: int = 0
	var full_path: String = "user://" + export_path + str(index) + ".png"
	var exists: bool = file.file_exists(full_path)
	while(exists):
		index += 1
		full_path = "user://" + export_path + str(index) + ".png"
		exists = file.file_exists(full_path)
	var error: int = ResourceSaver.save(full_path, export_texture)
	if error != OK:
		print("Error code: ", error)
	else:
		print("Exporting Capture")
