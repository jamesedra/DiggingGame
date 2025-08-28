function world_on_tile_instance_mark_air(_col, _row) {
    if (!variable_global_exists("World") || is_undefined(global.World)) return;
    var W = global.World;

    // 1) flip data grid to AIR
    world_set_tile(_col, _row, W.TILE_AIR);

    // 2) clear the visuals cell so we don't keep a stale instance id
    if (variable_struct_exists(W, "vis_chunk")) {
        var cc  = world_worldcol_to_chunkcol(_col);
        var cr  = world_worldrow_to_chunkrow(_row);
        var key = world_chunk_key(cc, cr);
        if (ds_map_exists(W.vis_chunk, key)) {
            var vg = ds_map_find_value(W.vis_chunk, key);
            var lx = _col - cc * W.chunk_w;
            var ly = _row - cr * W.chunk_h;
            ds_grid_set(vg, lx, ly, noone);
        }
    }
}