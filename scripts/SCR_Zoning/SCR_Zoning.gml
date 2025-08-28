function __zone_make(_id) {
    var W = global.World;
    ds_map_set(W.zone_parent, _id, _id);
    ds_map_set(W.zone_size,   _id, 0);
    ds_map_set(W.zone_bbox,   _id, [999999, -999999, 999999, -999999]); // minC,maxC,minR,maxR
}

function __zone_find(_id) {
    var W = global.World;
    var p = ds_map_find_value(W.zone_parent, _id);
    if (p != _id) {
        var r = __zone_find(p);
        ds_map_replace(W.zone_parent, _id, r);
        return r;
    }
    return _id;
}

function world_zone_union(_a, _b) {
    var W  = global.World;
    var ra = __zone_find(_a), rb = __zone_find(_b);
    if (ra == rb) return ra;

    var sa = ds_map_find_value(W.zone_size, ra);
    var sb = ds_map_find_value(W.zone_size, rb);

    // union by size
    if (sa < sb) { var t = ra; ra = rb; rb = t; var ts = sa; sa = sb; sb = ts; }

    ds_map_replace(W.zone_parent, rb, ra);
    ds_map_replace(W.zone_size,   ra, sa + sb);

    // merge bbox
    var ba = ds_map_find_value(W.zone_bbox, ra);
    var bb = ds_map_find_value(W.zone_bbox, rb);
    ba[0] = min(ba[0], bb[0]); // minC
    ba[1] = max(ba[1], bb[1]); // maxC
    ba[2] = min(ba[2], bb[2]); // minR
    ba[3] = max(ba[3], bb[3]); // maxR
    ds_map_replace(W.zone_bbox, ra, ba);

    return ra;
}

function __zone_bbox_extend(_id, _col, _row) {
    var W = global.World;
    var b = ds_map_find_value(W.zone_bbox, _id);
    b[0] = min(b[0], _col);
    b[1] = max(b[1], _col);
    b[2] = min(b[2], _row);
    b[3] = max(b[3], _row);
    ds_map_replace(W.zone_bbox, _id, b);
}

function world_zone_label_chunk(_ccol, _crow, _chunk_grid) {
    var W  = global.World;
    var gw = W.chunk_w, gh = W.chunk_h;

    // create labels grid for this chunk: 0 = not a zone cell
    var labels = ds_grid_create(gw, gh);
    ds_grid_set_region(labels, 0, 0, gw-1, gh-1, 0);

    var q = ds_queue_create();

    for (var ly = 0; ly < gh; ly++) {
        for (var lx = 0; lx < gw; lx++) {
            if (ds_grid_get(labels, lx, ly) != 0) continue;
            if (ds_grid_get(_chunk_grid, lx, ly) != W.TILE_AIR) continue;

            // new region id
            var zid = W.zone_next_id; W.zone_next_id += 1;
            __zone_make(zid);

            ds_grid_set(labels, lx, ly, zid);
            ds_queue_enqueue(q, lx); ds_queue_enqueue(q, ly);

            while (!ds_queue_empty(q)) {
                var cx = ds_queue_dequeue(q);
                var cy = ds_queue_dequeue(q);

                var col = _ccol * W.chunk_w + cx;
                var row = _crow * W.chunk_h + cy;

                // keep stats
                var rid = __zone_find(zid);
                var sz  = ds_map_find_value(W.zone_size, rid);
                ds_map_replace(W.zone_size, rid, sz + 1);
                __zone_bbox_extend(rid, col, row);

                // 4-neigh flood (tiles inside this chunk that are AIR & unlabeled)
                // left
                if (cx > 0) {
                    if (ds_grid_get(labels, cx-1, cy) == 0 && ds_grid_get(_chunk_grid, cx-1, cy) == W.TILE_AIR) {
                        ds_grid_set(labels, cx-1, cy, zid);
                        ds_queue_enqueue(q, cx-1); ds_queue_enqueue(q, cy);
                    }
                }
                // right
                if (cx < gw-1) {
                    if (ds_grid_get(labels, cx+1, cy) == 0 && ds_grid_get(_chunk_grid, cx+1, cy) == W.TILE_AIR) {
                        ds_grid_set(labels, cx+1, cy, zid);
                        ds_queue_enqueue(q, cx+1); ds_queue_enqueue(q, cy);
                    }
                }
                // up
                if (cy > 0) {
                    if (ds_grid_get(labels, cx, cy-1) == 0 && ds_grid_get(_chunk_grid, cx, cy-1) == W.TILE_AIR) {
                        ds_grid_set(labels, cx, cy-1, zid);
                        ds_queue_enqueue(q, cx); ds_queue_enqueue(q, cy-1);
                    }
                }
                // down
                if (cy < gh-1) {
                    if (ds_grid_get(labels, cx, cy+1) == 0 && ds_grid_get(_chunk_grid, cx, cy+1) == W.TILE_AIR) {
                        ds_grid_set(labels, cx, cy+1, zid);
                        ds_queue_enqueue(q, cx); ds_queue_enqueue(q, cy+1);
                    }
                }
            }
        }
    }

    ds_queue_destroy(q);
    ds_map_set(W.zone_chunk_labels, world_chunk_key(_ccol, _crow), labels);

    // merge with existing neighbor labels along borders (if those chunks exist)
    world_zone_merge_with_neighbors(_ccol, _crow);
}

function world_zone_merge_with_neighbors(_ccol, _crow) {
    var W = global.World;
    if (is_undefined(W.zone_chunk_labels)) return;

    var keyC = world_chunk_key(_ccol, _crow);
    if (!ds_map_exists(W.zone_chunk_labels, keyC)) return;

    var labC = ds_map_find_value(W.zone_chunk_labels, keyC);

    // ---- left neighbor (shares vertical edge)
    var keyL = world_chunk_key(_ccol - 1, _crow);
    if (ds_map_exists(W.zone_chunk_labels, keyL)) {
        var labL = ds_map_find_value(W.zone_chunk_labels, keyL);
        var xC = 0;                 // leftmost column of current
        var xL = W.chunk_w - 1;     // rightmost column of left chunk
        for (var r = 0; r < W.chunk_h; r++) {
            var idC = ds_grid_get(labC, xC, r);
            if (idC <= 0) continue;
            var idL = ds_grid_get(labL, xL, r);
            if (idL <= 0) continue;
            world_zone_union(idC, idL);
        }
    }

    // ---- right neighbor (vertical edge)
    var keyR = world_chunk_key(_ccol + 1, _crow);
    if (ds_map_exists(W.zone_chunk_labels, keyR)) {
        var labR = ds_map_find_value(W.zone_chunk_labels, keyR);
        var xCr = W.chunk_w - 1;    // right edge of current
        var xR  = 0;                // left edge of right chunk
        for (var r2 = 0; r2 < W.chunk_h; r2++) {
            var idCr = ds_grid_get(labC, xCr, r2);
            if (idCr <= 0) continue;
            var idR = ds_grid_get(labR, xR, r2);
            if (idR <= 0) continue;
            world_zone_union(idCr, idR);
        }
    }

    // ---- up neighbor (horizontal edge)
    var keyU = world_chunk_key(_ccol, _crow - 1);
    if (ds_map_exists(W.zone_chunk_labels, keyU)) {
        var labU = ds_map_find_value(W.zone_chunk_labels, keyU);
        var yU  = W.chunk_h - 1;    // bottom row of up chunk
        var yC0 = 0;                // top row of current
        for (var c = 0; c < W.chunk_w; c++) {
            var idU = ds_grid_get(labU, c, yU);
            if (idU <= 0) continue;
            var idC0 = ds_grid_get(labC, c, yC0);
            if (idC0 <= 0) continue;
            world_zone_union(idU, idC0);
        }
    }

    // ---- down neighbor (horizontal edge)
    var keyD = world_chunk_key(_ccol, _crow + 1);
    if (ds_map_exists(W.zone_chunk_labels, keyD)) {
        var labD = ds_map_find_value(W.zone_chunk_labels, keyD);
        var yC1 = W.chunk_h - 1;    // bottom row of current
        var yD  = 0;                // top row of down chunk
        for (var c2 = 0; c2 < W.chunk_w; c2++) {
            var idC1 = ds_grid_get(labC, c2, yC1);
            if (idC1 <= 0) continue;
            var idD  = ds_grid_get(labD, c2, yD);
            if (idD <= 0) continue;
            world_zone_union(idC1, idD);
        }
    }
}

function world_zones_spawn_for_chunk(_ccol, _crow) {
    var W   = global.World;
    var key = world_chunk_key(_ccol, _crow);
    if (!ds_map_exists(W.zone_chunk_labels, key)) return;

    var labels = ds_map_find_value(W.zone_chunk_labels, key);
    var gw = W.chunk_w, gh = W.chunk_h;

    // Collect unique zone roots present in THIS chunk
    var seen = ds_map_create();
    for (var ly = 0; ly < gh; ly++) {
        for (var lx = 0; lx < gw; lx++) {
            var lid = ds_grid_get(labels, lx, ly);
            if (lid <= 0) continue;
            var rid = __zone_find(lid);
            if (!ds_map_exists(seen, rid)) ds_map_add(seen, rid, 1);
        }
    }

    // For each zone present in this chunk
    var k = ds_map_find_first(seen);
    while (!is_undefined(k)) {
        var rid   = real(k);
        var zsize = ds_map_find_value(W.zone_size, rid);

        if (zsize >= W.zone_min_cells) {
            // compute the zone's total goal once
            var goal;
            if (ds_map_exists(W.zone_spawn_goal, rid)) {
                goal = ds_map_find_value(W.zone_spawn_goal, rid);
            } else {
                goal = max(1, ceil(zsize / W.zone_cells_per_spawn)); // e.g., 1 per 150 cells
                ds_map_add(W.zone_spawn_goal, rid, goal);
            }

            var have   = ds_map_exists(W.zone_spawn_count, rid) ? ds_map_find_value(W.zone_spawn_count, rid) : 0;
            var remain = max(0, goal - have);
            if (remain > 0) {
                var to_place = min(remain, W.zone_spawns_per_chunk_cap);

                // Build a list of all AIR cells in THIS CHUNK that belong to this zone
                var cells = ds_list_create();
                for (var y1 = 0; y1 < gh; y1++) {
                    for (var x1 = 0; x1 < gw; x1++) {
                        var lid2 = ds_grid_get(labels, x1, y1);
                        if (lid2 <= 0) continue;
                        if (__zone_find(lid2) != rid) continue;
                        ds_list_add(cells, y1 * gw + x1);
                    }
                }

                var available  = ds_list_size(cells);
                var will_place = min(to_place, available);

                var placed = 0;
                repeat (will_place) {
                    if (ds_list_size(cells) <= 0) break;
                    var idx    = irandom(ds_list_size(cells) - 1);
                    var packed = ds_list_find_value(cells, idx);
                    ds_list_delete(cells, idx);

                    var lx = packed mod gw;
                    var ly = packed div gw;

                    var wcol = _ccol * W.chunk_w + lx;
                    var wrow = _crow * W.chunk_h + ly;
					
                    // tile below (for floor spawns) and tile above (for ceiling spawns)
                    var t_below = world_get_tile(wcol, wrow + 1);
                    var t_above = world_get_tile(wcol, wrow - 1);

                    // helper: solid = not AIR and not WATER and defined
                    var solid_below = !is_undefined(t_below) && t_below != W.TILE_AIR && t_below != W.TILE_WATER;
                    var solid_above = !is_undefined(t_above) && t_above != W.TILE_AIR && t_above != W.TILE_WATER;

                    // screen/world coordinates (center of this cell)
                    var px = wcol * W.tileSize + (W.tileSize * 0.5);
                    var py = wrow * W.tileSize + (W.tileSize * 0.5);
					
					if (py < W.min_spawn_depth) continue; // spawn only after certain depth

                    // Decide whether to do a ceiling spawn (if there's a solid above),
                    // otherwise do the original floor spawn (requires solid below).
                    var spawn_on_ceiling = solid_above;
                    if (!spawn_on_ceiling && !solid_below) {
                        // not ground, not ceiling -> skip
                        continue;
                    }

                    // If you require a visual instance to be present as "ground",
                    // check the appropriate position (above for ceiling, below for floor)
                    if (W.zone_require_instance_ground) {
                        if (spawn_on_ceiling) {
                            var above_inst = noone;
                            // prefer parent object if present
                            if (object_exists(oBlock)) {
                                // check center of the *tile above*
                                above_inst = instance_position(px, py - W.tileSize, oBlock);
                            }
                            if (above_inst == noone && object_exists(oDirt)) {
                                above_inst = instance_position(px, py - W.tileSize, oDirt);
                            }
                            if (above_inst == noone && object_exists(oRock)) {
                                above_inst = instance_position(px, py - W.tileSize, oRock);
                            }
                            if (above_inst == noone) {
                                continue; // no visual ceiling found, skip
                            }
                        } else {
                            var below_inst = noone;
                            if (object_exists(oBlock)) {
                                below_inst = instance_position(px, py + W.tileSize, oBlock);
                            }
                            if (below_inst == noone && object_exists(oDirt)) {
                                below_inst = instance_position(px, py + W.tileSize, oDirt);
                            }
                            if (below_inst == noone && object_exists(oRock)) {
                                below_inst = instance_position(px, py + W.tileSize, oRock);
                            }
                            if (below_inst == noone) {
                                continue; // no visual ground found, skip
                            }
                        }
                    }

                    // Choose spawnable depending on ceiling vs floor
                    var inst_x = px;
                    var inst_y = py;
                    var obj_to_make = noone;

                    if (spawn_on_ceiling) {
                        // ceiling spawn
                        inst_y = (wrow) * W.tileSize + (W.tileSize * 0.5);
						obj_to_make = oStalagmite;
                    } else {
                        // floor spawn (original behavior)
                        // inst_y stays as center of this tile
                        obj_to_make = choose(oChest_Wood, oDirt, oDrill_Red);
                    }

                    if (!is_undefined(obj_to_make) && obj_to_make != noone) {
                        var inst = instance_create_layer(inst_x, inst_y, W.vis_layer, obj_to_make);
                        if (!is_undefined(inst)) placed += 1;
                    }
                }

                ds_list_destroy(cells);

                if (placed > 0) {
                    have += placed;
                    if (ds_map_exists(W.zone_spawn_count, rid)) {
                        ds_map_replace(W.zone_spawn_count, rid, have);
                    } else {
                        ds_map_add(W.zone_spawn_count, rid, have);
                    }
                }
            }
        }

        k = ds_map_find_next(seen, k);
    }

    ds_map_destroy(seen);
}


