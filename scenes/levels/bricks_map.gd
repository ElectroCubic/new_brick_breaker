extends TileMap

var blockCount: int = 0

func _ready():
	var cells = get_used_cells(0)
	
	for tile_pos in cells:
		var tile_data = get_cell_tile_data(0,tile_pos)
		var custom_data = tile_data.get_custom_data_by_layer_id(0)
		if custom_data >= 2:
			blockCount += 1
		
	Globals.blocks = blockCount
