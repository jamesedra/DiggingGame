function __count8(_G, _ix, _iy) {
    var n = 0;
    n += (ds_grid_get(_G, _ix-1, _iy-1) == 1);
    n += (ds_grid_get(_G, _ix,   _iy-1) == 1);
    n += (ds_grid_get(_G, _ix+1, _iy-1) == 1);
    n += (ds_grid_get(_G, _ix-1, _iy  ) == 1);
    n += (ds_grid_get(_G, _ix+1, _iy  ) == 1);
    n += (ds_grid_get(_G, _ix-1, _iy+1) == 1);
    n += (ds_grid_get(_G, _ix,   _iy+1) == 1);
    n += (ds_grid_get(_G, _ix+1, _iy+1) == 1);
    return n;
}

/// Applies CA to carve caves ONLY in STONE cells of the given chunk grid.
function world_ca_carve_chunk(_ccol, _crow, _g) {
    var W   = global.World;
    var pad = max(W.chunk_pad, W.ca_iters + 1);
    var lw  = W.chunk_w + pad * 2;
    var lh  = W.chunk_h + pad * 2;

    var A = ds_grid_create(lw, lh); // 1 = wall, 0 = cave
    var B = ds_grid_create(lw, lh);
    ds_grid_set_region(A, 0, 0, lw-1, lh-1, 1);

    // --- 1) Seed (deterministic), forbid caves near surface
    for (var ly = 0; ly < lh; ly++) {
        var wrow = _crow * W.chunk_h + (ly - pad);
        for (var lx = 0; lx < lw; lx++) {
            var wcol = _ccol * W.chunk_w + (lx - pad);

            if (wcol < 0 || wcol >= W.cols || wrow < 0 || wrow >= W.rows) {
                ds_grid_set(A, lx, ly, 1);
                continue;
            }

            var surf_row = W.surface_heights[wcol];
            if (wrow < surf_row + W.ca_start_offset) {
                ds_grid_set(A, lx, ly, 1);
            } else {
                var r = world_hash01(wcol, wrow, W.seed + 13579);
                ds_grid_set(A, lx, ly, (r < W.ca_fill_chance) ? 0 : 1); // 0=cave, 1=wall
            }
        }
    }

    // --- 2) Smoothing (classic 4–5 Moore rule; NO self in the count)
    for (var it = 0; it < W.ca_iters; it++) {
	    var birth = 4;  // cave -> wall if > 4 wall neighbors (easier to fill caves)
	    var death = 4;  // wall stays wall if >= 4 wall neighbors (walls survive more)

	    for (var iy = 1; iy < lh - 1; iy++) {
	        for (var ix = 1; ix < lw - 1; ix++) {
	            var walls = __count8(A, ix, iy);
	            var cur   = ds_grid_get(A, ix, iy); // 1=wall, 0=cave
	            var nxt;
	            if (cur == 0) {
	                // fill caves more aggressively
	                nxt = (walls > birth) ? 1 : 0;
	            } else {
	                // keep walls with only 4 neighbors (don’t erode too fast)
	                nxt = (walls >= death) ? 1 : 0;
	            }
	            ds_grid_set(B, ix, iy, nxt);
	        }
	    }

	    // keep a solid border to preserve seams
	    for (var bx = 0; bx < lw; bx++) { ds_grid_set(B, bx, 0, 1); ds_grid_set(B, bx, lh-1, 1); }
	    for (var by = 0; by < lh; by++) { ds_grid_set(B, 0,  by, 1); ds_grid_set(B, lw-1, by, 1); }

	    var T = A; A = B; B = T;
	}
	
    // --- 3) Apply to chunk interior: carve STONE -> AIR where A==0
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