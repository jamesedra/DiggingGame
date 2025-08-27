/// world_ca_carve_chunk(_ccol, _crow, _grid_chunk)
/// Applies CA to carve caves ONLY in STONE cells of the given chunk grid.
function world_ca_carve_chunk(_ccol, _crow, _g) {
    var W   = global.World;
    var pad = max(W.chunk_pad, W.ca_iters + 1);
    var lw  = W.chunk_w + pad * 2;
    var lh  = W.chunk_h + pad * 2;

    var A = ds_grid_create(lw, lh); // 1=wall, 0=cave
    var B = ds_grid_create(lw, lh);
    ds_grid_set_region(A, 0, 0, lw-1, lh-1, 1);

    // 1) initialize (deterministic), forbid caves near surface
    for (var ly = 0; ly < lh; ly++) {
        var world_row = _crow * W.chunk_h + (ly - pad);
        for (var lx = 0; lx < lw; lx++) {
            var world_col = _ccol * W.chunk_w + (lx - pad);

            if (world_col < 0 || world_col >= W.cols || world_row < 0 || world_row >= W.rows) {
                ds_grid_set(A, lx, ly, 1);
                continue;
            }

            var surf_row = W.surface_heights[world_col];
            if (world_row < surf_row + W.ca_start_offset) {
                ds_grid_set(A, lx, ly, 1);
            } else {
                var r = world_hash01(world_col, world_row, W.seed + 13579);
                ds_grid_set(A, lx, ly, (r < W.ca_fill_chance) ? 0 : 1);
            }
        }
    }

    // 2) smoothing passes (Moore)
    for (var it = 0; it < W.ca_iters; it++) {
        for (var iy = 1; iy < lh - 1; iy++) {
            for (var ix = 1; ix < lw - 1; ix++) {
                var walls = 0;
                for (var jy = iy - 1; jy <= iy + 1; jy++) {
                    for (var jx = ix - 1; jx <= ix + 1; jx++) {
                        if (ds_grid_get(A, jx, jy) == 1) walls++;
                    }
                }
                ds_grid_set(B, ix, iy, (walls >= 5) ? 1 : 0);
            }
        }
        // clamp borders as walls
        for (var bx = 0; bx < lw; bx++) { ds_grid_set(B, bx, 0, 1); ds_grid_set(B, bx, lh-1, 1); }
        for (var by = 0; by < lh; by++) { ds_grid_set(B, 0, by, 1); ds_grid_set(B, lw-1, by, 1); }

        var T = A; A = B; B = T; // swap
    }

    // 3) apply to real chunk interior: carve STONE -> AIR where A==0
    for (var cy = 0; cy < W.chunk_h; cy++) {
        for (var cx = 0; cx < W.chunk_w; cx++) {
            if (ds_grid_get(A, pad + cx, pad + cy) == 0) {
                if (ds_grid_get(_g, cx, cy) == W.TILE_STONE) {
                    ds_grid_set(_g, cx, cy, W.TILE_AIR);
                }
            }
        }
    }

    ds_grid_destroy(A);
    ds_grid_destroy(B);
}