// randomizer call
randomize();

var world_cols = 2048;
var world_rows = 5096;
var tile_sz    = 16;
var seed_val   = random(10000000);
var chw        = 32;
var chh        = 16;

world_init(world_cols, world_rows, tile_sz, seed_val, chw, chh);

// map tiles
function world_vis_config_objects() {
    var W = global.World;
    W.tile_to_obj = array_create(16, noone);
    W.tile_to_obj[W.TILE_GRASS] = oGrass;
    W.tile_to_obj[W.TILE_DIRT]  = oDirt;
    W.tile_to_obj[W.TILE_STONE] = oRock;
	W.tile_to_obj[W.TILE_GEMRED] = oGem_Red;
	W.tile_to_obj[W.TILE_GEMBLUE] = oGem_Blue;
	W.tile_to_obj[W.TILE_GEMYELLOW] = oGem_Yellow;
    // AIR/WATER stay noone (no instance)
}

// visuals state
function world_vis_init(_layer_name) {
    var W = global.World;
    W.vis_layer = _layer_name;      // e.g. "World"
    W.vis_chunk = ds_map_create();  // "cx,cy" -> ds_grid of instance ids
}

world_vis_init("World");
world_vis_config_objects();

// init streaming and request just the visible room area once
world_stream_init(2); // generate up to 2 chunks per Step

var cols_vis = (room_width  div tile_sz);
var rows_vis = (room_height div tile_sz);
world_request_chunks_rect(0, 0, cols_vis - 1, rows_vis - 1);