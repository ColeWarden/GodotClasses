# TileMapCapture Class

TileMapCapture exports a png by stitching together all the tiles within a boundary box

## Before
![before](https://user-images.githubusercontent.com/59773291/148150254-f9fde7a9-79ba-4766-8609-202deec8e2c4.PNG)

## After
![after](https://user-images.githubusercontent.com/59773291/148150266-77171703-1794-4e72-aee2-309edb443951.PNG)

## Parameters
- TileMapCapture has two Position2D nodes, Begin and End. Both create the bounding box of what you want to capture

- `tilemap_node_paths` - An Array of nodepaths to all tilemaps you want to be screen captured.

- `tilemap_size` - Cell size of the tilemaps. Will not work if tilemaps have different cell sizes.

- `export_path` - What the texture's path will be. Will be save under "user://".

- `tile_edges_only` - TileMapCapture will only capture tiles that are edges. 

`tile_edges_only` = Disabled:

![export_capture_0](https://user-images.githubusercontent.com/59773291/148151136-8273e53e-700e-4cf3-83da-cb6329df2225.png)

`tile_edges_only` = Enabled:

![export_capture_1](https://user-images.githubusercontent.com/59773291/148151141-ca1dfc8e-5203-4fdc-b82b-aeeebf2b83bb.png)

- `surrounded_tile_auto_cord` - If `tile_edges_only` is disabled, set the tile's auto cord you want to remove.

- `snap_begin_and_end` - Snaps the Begin and End's global_position to `tilemap_size`. 


