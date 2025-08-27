function world_init(_cols, _rows, _tile_size, _seed, _chunk_w, _chunk_h) {
    // create the global holder if needed
    if (!variable_global_exists("World") || is_undefined(global.World)) {
        global.World = {};
    }
    var W = global.World;

    // basic config
    W.cols      = _cols;
    W.rows      = _rows;
    W.tileSize  = _tile_size;
    W.seed      = _seed;

    // chunking
    W.chunk_w   = _chunk_w;
    W.chunk_h   = _chunk_h;
    W.chunk_pad = 2;

    // tile ids
    W.TILE_AIR   = 0;
    W.TILE_GRASS = 1;
    W.TILE_DIRT  = 2;
    W.TILE_STONE = 3;
    W.TILE_WATER = 4;

    // terrain params
    W.surface_base_row  = 16;
    W.surface_amplitude = 28;
    W.surface_freq      = 0.008;
    W.surface_octaves   = 4;

    W.gdepth_mean = 24;
    W.gdepth_var  = 8;
    W.gdepth_freq = 0.01;

    // arrays
    W.surface_heights = array_create(W.cols, 0);
    W.ground_base     = array_create(W.cols, 0);
	
	// CA (caves) params
	W.ca_fill_chance   = 0.005; // 0..1 : initial chance to be CAVE in the deep area
	W.ca_iters         = 2;    // smoothing passes (3..6 typical)
	W.ca_start_offset  = 6;    // tiles below surface before caves may appear
	
	// Neighborhood influence expands ~= iters tiles. Make sure pad covers it.
	W.chunk_pad = max(W.chunk_pad, W.ca_iters + 1);

    // chunk storage map — use variable_struct_exists to avoid reading a missing field
	if (variable_struct_exists(W, "chunk_map") && ds_exists(W.chunk_map, ds_type_map)) {
	    var _m = W.chunk_map;
	    var _k = ds_map_find_first(_m);
	    while (!is_undefined(_k)) {
	        var _grid_id = ds_map_find_value(_m, _k);
	        if (ds_exists(_grid_id, ds_type_grid)) ds_grid_destroy(_grid_id);
	        _k = ds_map_find_next(_m, _k);
	    }
	    ds_map_clear(_m);
	} else {
	    W.chunk_map = ds_map_create();
	}

    // instance map (optional) — same safe pattern
    if (variable_struct_exists(W, "inst_map")) {
        if (ds_exists(W.inst_map, ds_type_map)) {
            ds_map_clear(W.inst_map);
        } else {
            W.inst_map = ds_map_create();
        }
    } else {
        W.inst_map = ds_map_create();
    }

    // compute per-column surface / ground base
    world_generate_columns();
}


// Destroy all DS when quitting/changing
function world_shutdown() {
    if (!variable_global_exists("World") || is_undefined(global.World)) return;
    var W = global.World;

    // stop generation DS first (if you added streaming)
    if (variable_struct_exists(W, "gen_queue") && ds_exists(W.gen_queue, ds_type_queue)) {
        ds_queue_destroy(W.gen_queue);
        W.gen_queue = undefined;
    }
    if (variable_struct_exists(W, "gen_pending") && ds_exists(W.gen_pending, ds_type_map)) {
        ds_map_destroy(W.gen_pending);
        W.gen_pending = undefined;
    }

    // destroy all chunk grids, then the map
    if (variable_struct_exists(W, "chunk_map") && ds_exists(W.chunk_map, ds_type_map)) {
        var _m = W.chunk_map;
        var _k = ds_map_find_first(_m);
        while (!is_undefined(_k)) {
            var _grid_id = ds_map_find_value(_m, _k);
            if (ds_exists(_grid_id, ds_type_grid)) ds_grid_destroy(_grid_id);
            _k = ds_map_find_next(_m, _k);
        }
        ds_map_destroy(_m);
        W.chunk_map = undefined;
    }

    // destroy instance map if you use it (not storing DS inside it yet)
    if (variable_struct_exists(W, "inst_map") && ds_exists(W.inst_map, ds_type_map)) {
        ds_map_destroy(W.inst_map);
        W.inst_map = undefined;
    }

    global.World = undefined;
}

// compute per-column surface & ground rows
function world_generate_columns() {
    var W = global.World;
    var base_row = clamp(W.surface_base_row, 8, W.rows - 64);

    for (var col_i = 0; col_i < W.cols; col_i++) {
        var nVal = world_valueNoise1D(col_i, W.surface_freq, W.surface_octaves, W.seed);
        var s_row = base_row + floor((nVal - 0.5) * W.surface_amplitude);
        s_row = clamp(s_row, 8, W.rows - 64);
        W.surface_heights[col_i] = s_row;

        var dn   = world_valueNoise1D(col_i + 9999, W.gdepth_freq, 2, W.seed + 7777);
        var gdep = W.gdepth_mean + floor((dn - 0.5) * 2 * W.gdepth_var);
        gdep = max(4, gdep);
        var g_base = clamp(s_row + gdep, s_row + 2, W.rows - 6);
        W.ground_base[col_i] = g_base;
    }
}