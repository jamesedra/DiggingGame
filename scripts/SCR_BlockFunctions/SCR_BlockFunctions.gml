function world_on_tile_instance_destroyed(_col, _row) {
    var W = global.World;
    world_set_tile(_col, _row, W.TILE_AIR);

    // also clear the vis entry so we don't keep a stale id
    var cc  = world_worldcol_to_chunkcol(_col);
    var cr  = world_worldrow_to_chunkrow(_row);
    var key = world_chunk_key(cc, cr);
    if (ds_map_exists(W.vis_chunk, key)) {
        var vis_g = ds_map_find_value(W.vis_chunk, key);
        var lx = _col - cc * W.chunk_w;
        var ly = _row - cr * W.chunk_h;
        ds_grid_set(vis_g, lx, ly, noone);
    }
}
