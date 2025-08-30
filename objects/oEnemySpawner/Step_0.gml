/// get_enemy_dims(_obj)
// returns array [w, h, offset_x, offset_y]
// caches result in size_cache
function get_enemy_dims(_obj) {
    var key = string(_obj);
    if (ds_map_exists(size_cache, key)) {
        return ds_map_find_value(size_cache, key);
    }

    // create a temporary invisible instance off-screen to read bbox
    var tx = -10000;
    var ty = -10000;
    var tmp = instance_create_layer(tx, ty, spawn_layer, _obj);
    if (!instance_exists(tmp)) {
        // fallback: use sprite_get_width/height if available (best-effort)
        var fallback_w = 32;
        var fallback_h = 48;
        var arr = [fallback_w, fallback_h, 0, 0];
        ds_map_add(size_cache, key, arr);
        return arr;
    }

    // make sure the temp instance uses default frame & not animating
    tmp.image_speed = 0;
    tmp.visible = false;
    // ensure physics/other init ran by stepping once? Usually not needed in Create.
    // read absolute bbox coords
    var left   = tmp.bbox_left;
    var top    = tmp.bbox_top;
    var right  = tmp.bbox_right;
    var bottom = tmp.bbox_bottom;

    var w = right - left;
    var h = bottom - top;

    // offset from instance origin to bbox center:
    var bbox_cx = (left + right) * 0.5;
    var bbox_cy = (top + bottom) * 0.5;
    var offset_x = bbox_cx - tmp.x;
    var offset_y = bbox_cy - tmp.y;

    // destroy the temp instance now that we measured
    with (tmp) instance_destroy();

    var dims = [w, h, offset_x, offset_y];
    ds_map_add(size_cache, key, dims);
    return dims;
}

/// find_free_spawn_using_dims(_cx, _cy, _obj, _maxr, _step, _solid, _maxAttempts)
/// returns [spawn_x, spawn_y] or [-1,-1]
function find_free_spawn_using_dims(_cx, _cy, _obj, _maxr, _step, _solid, _maxAttempts) {
    var dims = get_enemy_dims(_obj);
    var w = dims[0], h = dims[1], offset_x = dims[2], offset_y = dims[3];

    var attempts = 0;
    for (var r = 0; r <= _maxr; r += _step) {
        var angle_step = max(12, 360 / max(6, floor(r / _step + 1)));
        for (var a = 0; a < 360; a += angle_step) {
            if (++attempts > _maxAttempts) return [-1, -1];
            var nx = _cx + lengthdir_x(r, a);
            var ny = _cy + lengthdir_y(r, a);

            // Because bbox center might not equal instance origin, adjust candidate by offset.
            // We want bbox center at nx,ny, so instance origin should be:
            var inst_x = nx - offset_x;
            var inst_y = ny - offset_y;

            var left   = nx - w * 0.5;
            var top    = ny - h * 0.5;
            var right  = nx + w * 0.5;
            var bottom = ny + h * 0.5;

            // collision_rectangle uses room coords; test against _solid
            if (collision_rectangle(left, top, right, bottom, _solid, true, false) == noone) {
                // return instance origin position (so when creating instance we set x=inst_x, y=inst_y)
                return [inst_x, inst_y];
            }
        }
    }
    return [-1, -1];
}

// example: when player near and no enemy
var pl = instance_nearest(x, y, oPlayer);
if (!instance_exists(pl)) exit;
var d = point_distance(x, y, pl.x, pl.y);

if (d <= spawn_radius && current_enemy == noone && !permanently_slain) {
    var pos = find_free_spawn_using_dims(x + spawn_offset_x, y + spawn_offset_y,
                                         enemy_type, 96, spawn_step, solid_obj, spawn_attempts);

    if (pos[0] != -1) {
        current_enemy = instance_create_layer(pos[0], pos[1], spawn_layer, enemy_type);
        if (instance_exists(current_enemy)) current_enemy.spawned_by = id;
    } else {
        // fallback: skip or use push-out fallback from earlier message
        // show_debug_message("No free spot for " + string(enemy_type) + " — skipping spawn.");
    }
}
