// Step 1 = base fill only (AIR/GRASS/DIRT/STONE). CA will be added in Step 2.

// Create a new chunk grid (chunk_w x chunk_h) with base fill
function world_generate_chunk(_ccol, _crow) {
    var W = global.World;
    var g = ds_grid_create(W.chunk_w, W.chunk_h);

    for (var lx = 0; lx < W.chunk_w; lx++) {
        for (var ly = 0; ly < W.chunk_h; ly++) {
            var col = _ccol * W.chunk_w + lx;
            var row = _crow * W.chunk_h + ly;

            if (col < 0 || col >= W.cols || row < 0 || row >= W.rows) {
                ds_grid_set(g, lx, ly, W.TILE_AIR);
                continue;
            }

            var sH = W.surface_heights[col];
            var gB = W.ground_base[col];

            if (row < sH)              ds_grid_set(g, lx, ly, W.TILE_AIR);
            else if (row == sH)        ds_grid_set(g, lx, ly, W.TILE_GRASS);
            else if (row > sH && row < gB) ds_grid_set(g, lx, ly, W.TILE_DIRT);
            else                       ds_grid_set(g, lx, ly, W.TILE_STONE);
        }
    }
    return g;
}

// Get (or create) a chunk grid
function world_get_or_create_chunk(_ccol, _crow) {
    var W = global.World;
    var key = world_chunk_key(_ccol, _crow);
    if (ds_map_exists(W.chunk_map, key)) {
        return ds_map_find_value(W.chunk_map, key);
    } else {
        var ch = world_generate_chunk(_ccol, _crow);
        ds_map_add(W.chunk_map, key, ch);
        return ch;
    }
}

// Read a tile (returns undefined if chunk not present)
function world_get_tile(_col, _row) {
    var W = global.World;
    if (_col < 0 || _row < 0 || _col >= W.cols || _row >= W.rows) return W.TILE_AIR;

    var cc = world_worldcol_to_chunkcol(_col);
    var cr = world_worldrow_to_chunkrow(_row);
    var key = world_chunk_key(cc, cr);
    if (!ds_map_exists(W.chunk_map, key)) return undefined;

    var ch = ds_map_find_value(W.chunk_map, key);
    var lx = _col - cc * W.chunk_w;
    var ly = _row - cr * W.chunk_h;
    return ds_grid_get(ch, lx, ly);
}

// Write a tile (creates chunk if needed)
function world_set_tile(_col, _row, _tile_id) {
    var W = global.World;
    if (_col < 0 || _row < 0 || _col >= W.cols || _row >= W.rows) return false;

    var cc = world_worldcol_to_chunkcol(_col);
    var cr = world_worldrow_to_chunkrow(_row);
    var ch = world_get_or_create_chunk(cc, cr);

    var lx = _col - cc * W.chunk_w;
    var ly = _row - cr * W.chunk_h;
    ds_grid_set(ch, lx, ly, _tile_id);
    return true;
}

// Solid test (AIR/WATER are not solid)
function world_is_solid(_col, _row) {
    var W = global.World;
    var t = world_get_tile(_col, _row);
    if (is_undefined(t)) return true; // not generated -> treat as solid or force-create
    if (t == W.TILE_AIR) return false;
    if (t == W.TILE_WATER) return false;
    return true;
}

function world_request_chunks_for_camera(_cam, _margin_tiles) {
    var W  = global.World;
    var vx = camera_get_view_x(_cam);
    var vy = camera_get_view_y(_cam);
    var vw = camera_get_view_width(_cam);
    var vh = camera_get_view_height(_cam);

    var col0 = floor(vx / W.tileSize) - _margin_tiles;
    var row0 = floor(vy / W.tileSize) - _margin_tiles;
    var col1 = floor((vx + vw - 1) / W.tileSize) + _margin_tiles;
    var row1 = floor((vy + vh - 1) / W.tileSize) + _margin_tiles;

    world_request_chunks_rect(col0, row0, col1, row1);
}

function world_vis_build_chunk(_ccol, _crow) {
    var W = global.World;
    var key = world_chunk_key(_ccol, _crow);

    if (ds_map_exists(W.vis_chunk, key)) return; // already built

    // must have data chunk first
    var data_chunk = world_get_or_create_chunk(_ccol, _crow);
    var gw = W.chunk_w, gh = W.chunk_h;

    var vis_grid = ds_grid_create(gw, gh);
    ds_grid_set_region(vis_grid, 0, 0, gw-1, gh-1, noone);

    for (var lx = 0; lx < gw; lx++) {
        for (var ly = 0; ly < gh; ly++) {
            var t = ds_grid_get(data_chunk, lx, ly);
            if (t == W.TILE_AIR || t == W.TILE_WATER) continue;

            var obj_to_create = W.tile_to_obj[t];
            if (obj_to_create == noone) continue;

            var col = _ccol * W.chunk_w + lx;
            var row = _crow * W.chunk_h + ly;

            // center of the tile in room space
            var px = col * W.tileSize + (W.tileSize / 2);
            var py = row * W.tileSize + (W.tileSize / 2);

            var inst = instance_create_layer(px, py, W.vis_layer, obj_to_create);
            // tag the instance so digging can update the grid
            inst.gcol = col; inst.grow = row; inst.tile_type = t;

            ds_grid_set(vis_grid, lx, ly, inst);
        }
    }

    ds_map_add(W.vis_chunk, key, vis_grid);
}

function world_vis_clear_chunk(_ccol, _crow) {
    var W = global.World;
    var key = world_chunk_key(_ccol, _crow);
    if (!ds_map_exists(W.vis_chunk, key)) return;

    var g = ds_map_find_value(W.vis_chunk, key);
    var gw = ds_grid_width(g), gh = ds_grid_height(g);

    for (var lx = 0; lx < gw; lx++) {
        for (var ly = 0; ly < gh; ly++) {
            var inst = ds_grid_get(g, lx, ly);
            if (inst != noone && instance_exists(inst)) instance_destroy(inst);
        }
    }
    ds_grid_destroy(g);
    ds_map_delete(W.vis_chunk, key);
}

function world_vis_build_for_camera(_cam) {
    var W  = global.World;
    var vx = camera_get_view_x(_cam), vy = camera_get_view_y(_cam);
    var vw = camera_get_view_width(_cam), vh = camera_get_view_height(_cam);

    var col0 = floor(vx / W.tileSize);
    var row0 = floor(vy / W.tileSize);
    var col1 = floor((vx + vw - 1) / W.tileSize);
    var row1 = floor((vy + vh - 1) / W.tileSize);

    var cc0 = world_worldcol_to_chunkcol(col0);
    var cr0 = world_worldrow_to_chunkrow(row0);
    var cc1 = world_worldcol_to_chunkcol(col1);
    var cr1 = world_worldrow_to_chunkrow(row1);

    for (var cc = cc0; cc <= cc1; cc++) {
        for (var cr = cr0; cr <= cr1; cr++) {
            var key = world_chunk_key(cc, cr);
            // only build if data exists (generated already)
            if (ds_map_exists(W.chunk_map, key)) world_vis_build_chunk(cc, cr);
        }
    }
}

function world_vis_clear_outside_radius(_cam, _radius_chunks) {
    var W  = global.World;
    var vx = camera_get_view_x(_cam), vy = camera_get_view_y(_cam);
    var vw = camera_get_view_width(_cam), vh = camera_get_view_height(_cam);
    var mid_col = floor((vx + vw * 0.5) / W.tileSize);
    var mid_row = floor((vy + vh * 0.5) / W.tileSize);
    var cc_mid  = world_worldcol_to_chunkcol(mid_col);
    var cr_mid  = world_worldrow_to_chunkrow(mid_row);

    var m = W.vis_chunk;
    var k = ds_map_find_first(m);
    while (!is_undefined(k)) {
        var parts = string_split(k, ",");
        var cc = real(parts[0]), cr = real(parts[1]);
        var dist = max(abs(cc - cc_mid), abs(cr - cr_mid));
        if (dist > _radius_chunks) {
            world_vis_clear_chunk(cc, cr);
            // restart iteration because we mutated the map
            k = ds_map_find_first(m);
        } else {
            k = ds_map_find_next(m, k);
        }
    }
}
