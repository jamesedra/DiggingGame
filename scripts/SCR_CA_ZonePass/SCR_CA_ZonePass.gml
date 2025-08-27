function world_tile_to_zonecol(_col) {
    var W = global.World; return floor(_col / W.zone_w);
}
function world_tile_to_zonerow(_row) {
    var W = global.World; return floor(_row / W.zone_h);
}
function world_zone_key(_zc, _zr) {
    return string(_zc) + "," + string(_zr);
}

// Create or fetch a zone bucket.
// We count *all* tiles seen (covered), but the AIR ratio is computed
// only on "eligible" underground tiles (not sky).
function world_zone_get_or_create(_zc, _zr) {
    var W = global.World;
    var key = world_zone_key(_zc, _zr);
    if (ds_map_exists(W.zone_map, key)) return ds_map_find_value(W.zone_map, key);

    var z = {
        zc: _zc, zr: _zr,
        // accounting
        covered: 0,                     // all tiles (sky+ground) we have visited
        total:   W.zone_w * W.zone_h,   // fixed: zone footprint
        elig_total: 0,                  // underground tiles considered
        elig_air:   0,                  // underground tiles that are AIR
        // results
        active: false,
        finalized: false,
        tag: W.ZONE_NONE
    };
    ds_map_add(W.zone_map, key, z);
    return z;
}

function world_zone_finalize_if_ready(_z) {
    if (_z.finalized) return;
    if (_z.covered < _z.total) return;           // wait until all tiles in zone were seen

    var W = global.World;
    var ratio = (_z.elig_total > 0) ? (_z.elig_air / _z.elig_total) : 0.0;

    _z.active = (ratio >= W.zone_threshold);
    if (_z.active) {
        // deterministic tag (so it’s stable across runs for a given seed)
        var r = world_hash01(_z.zc, _z.zr, W.seed + 777);
        _z.tag = (r < 0.5) ? W.ZONE_LOOT : W.ZONE_MONSTER;
    } else {
        _z.tag = W.ZONE_NONE;
    }
    _z.finalized = true;
}

// Convenience query
function world_zone_is_active_for_tile(_col, _row) {
    var zc = world_tile_to_zonecol(_col);
    var zr = world_tile_to_zonerow(_row);
    var key = world_zone_key(zc, zr);
    var W = global.World;
    if (!ds_map_exists(W.zone_map, key)) return false;
    var z = ds_map_find_value(W.zone_map, key);
    return z.finalized && z.active;
}

function world_zone_accumulate_from_chunk(_ccol, _crow, _g) {
    var W = global.World;

    for (var ly = 0; ly < W.chunk_h; ly++) {
        var row_world = _crow * W.chunk_h + ly;
        if (row_world < 0 || row_world >= W.rows) continue;

        for (var lx = 0; lx < W.chunk_w; lx++) {
            var col_world = _ccol * W.chunk_w + lx;
            if (col_world < 0 || col_world >= W.cols) continue;

            var zc = world_tile_to_zonecol(col_world);
            var zr = world_tile_to_zonerow(row_world);
            var z  = world_zone_get_or_create(zc, zr);

            // Count every tile once so we know when a zone is fully covered:
            z.covered++;

            // Only *underground* tiles contribute to the AIR ratio.
            // Use your column data to decide eligibility (skip sky).
            var sH = W.surface_heights[col_world];
            var eligible_row = max(W.ground_base[col_world], sH + W.ca_start_offset);
            var is_underground = (row_world >= eligible_row);

            if (is_underground) {
                z.elig_total++;
                var t = ds_grid_get(_g, lx, ly);
                if (t == W.TILE_AIR) z.elig_air++;
            }

            // Finalize when we've seen the whole 32x32 footprint.
            world_zone_finalize_if_ready(z);
        }
    }
}
