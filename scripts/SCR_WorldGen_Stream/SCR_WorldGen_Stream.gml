/// scr_world_stream.gml

// call once after world_init
function world_stream_init(_max_chunks_per_step) {
    var W = global.World;
    W.gen_queue = ds_queue_create();      // queue of "cx,cy" strings
    W.gen_pending = ds_map_create();      // set-like: key -> 1
    W.max_chunks_per_step = _max_chunks_per_step;
}

// request a single chunk
function world_request_chunk(_ccol, _crow) {
    var W = global.World;
    var key = world_chunk_key(_ccol, _crow);
    if (ds_map_exists(W.chunk_map, key)) return;          // already generated
    if (ds_map_exists(W.gen_pending, key)) return;        // already queued
    ds_queue_enqueue(W.gen_queue, key);
    ds_map_add(W.gen_pending, key, 1);
}

// request all chunks in a rect of global tile coords (inclusive)
function world_request_chunks_rect(_col0, _row0, _col1, _row1) {
    var W = global.World;
    var c0 = world_worldcol_to_chunkcol(clamp(_col0, 0, W.cols-1));
    var r0 = world_worldrow_to_chunkrow(clamp(_row0, 0, W.rows-1));
    var c1 = world_worldcol_to_chunkcol(clamp(_col1, 0, W.cols-1));
    var r1 = world_worldrow_to_chunkrow(clamp(_row1, 0, W.rows-1));
    var cc, rr;
    for (cc = c0; cc <= c1; cc++) {
        for (rr = r0; rr <= r1; rr++) world_request_chunk(cc, rr);
    }
}

// process up to N queued chunk generations per step
function world_step_process_generation() {
    var W = global.World;
    var n = W.max_chunks_per_step;

    while (n > 0 && !ds_queue_empty(W.gen_queue)) {
        var key   = ds_queue_dequeue(W.gen_queue);
        var parts = string_split(key, ",");
        var cx    = real(parts[0]);
        var cy    = real(parts[1]);

        // 1) Generate (or fetch) the DATA chunk grid
        var chunk_grid = world_get_or_create_chunk(cx, cy);

        // Safety guard (helps catch accidental nils)
        if (is_undefined(chunk_grid) || !ds_exists(chunk_grid, ds_type_grid)) {
            show_debug_message("ERROR: world_get_or_create_chunk returned undefined for " + key);
            // Ensure we don’t stay stuck on this key
            if (ds_map_exists(W.gen_pending, key)) ds_map_delete(W.gen_pending, key);
            n -= 1;
            continue;
        }

        // 2) Label/merge zones, then do one-time spawns (all based on AIR cells)
        world_zone_label_chunk(cx, cy, chunk_grid);
        world_zone_merge_with_neighbors(cx, cy);
        world_zones_spawn_for_chunk(cx, cy);

        // 3) Mark as completed
        if (ds_map_exists(W.gen_pending, key)) ds_map_delete(W.gen_pending, key);
        n -= 1;
    }
}
