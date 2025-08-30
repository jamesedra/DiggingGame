/// radial_offsets(count, radius, start_angle = 0, jitter = 0)
/// returns a GML array of [x,y] pairs
function radial_offsets(count, radius, start_angle, jitter) {
    if (argument_count < 3) start_angle = 0;
    if (argument_count < 4) jitter = 0;
    var out = array_create(count);
    var step = 360 / max(1, count);
    for (var i = 0; i < count; ++i) {
        var ang = degtorad(start_angle + i * step + irandom_range(-jitter, jitter));
        var ox = lengthdir_x(radius, radtodeg(ang)); // note: lengthdir_x expects degrees
        var oy = lengthdir_y(radius, radtodeg(ang));
        out[i] = [ox, oy];
    }
    return out;
}

/// spawn_explosions_from_offsets(_x, _y, _offsets, _layer_or_depth, _base_delay=0, _step_delay=2, _jitter=1, _owner=noone)
function spawn_explosions_from_offsets(_x, _y, _offsets, _layer_or_depth) {
    var created = ds_list_create();

    var base_delay = (argument_count >= 5) ? argument[4] : 0;
    var step_delay = (argument_count >= 6) ? argument[5] : 2;
    var jitter     = (argument_count >= 7) ? argument[6] : 1;
    var owner_ref  = (argument_count >= 8) ? argument[7] : noone;

    // decide layer vs depth
    var use_layer = false, layer_name = "";
    var forced_depth = undefined;
    if (is_string(_layer_or_depth)) {
        if (layer_get_id(_layer_or_depth) != -1) { use_layer = true; layer_name = _layer_or_depth; }
    } else if (is_real(_layer_or_depth)) {
        forced_depth = _layer_or_depth;
    }
    var base_depth = (!is_undefined(forced_depth)) ? forced_depth : (!is_undefined(depth) ? depth : 0);

    var idx = 0;

    if (is_array(_offsets)) {
        var n = array_length(_offsets);
        for (var i = 0; i < n; ++i) {
            var pair = _offsets[i];
            var ox = pair[0], oy = pair[1];

            var inst = use_layer
                ? instance_create_layer(_x + ox, _y + oy, layer_name, select_explosion())
                : instance_create_depth(_x + ox, _y + oy, base_depth, select_explosion());

            if (instance_exists(inst)) {
                inst.start_delay  = base_delay + idx * step_delay + irandom_range(-jitter, jitter);
                inst.owner_player = owner_ref;
                ds_list_add(created, inst);
                idx++;
            }
        }
        return created;
    }

    if (is_dslist(_offsets)) {
        var m = ds_list_size(_offsets);
        for (var j = 0; j < m; ++j) {
            var pair2 = ds_list_find_value(_offsets, j);
            var ox2 = pair2[0], oy2 = pair2[1];

            var inst2 = use_layer
                ? instance_create_layer(_x + ox2, _y + oy2, layer_name, select_explosion())
                : instance_create_depth(_x + ox2, _y + oy2, base_depth, select_explosion());

            if (instance_exists(inst2)) {
                inst2.start_delay  = base_delay + idx * step_delay + irandom_range(-jitter, jitter);
                inst2.owner_player = owner_ref;
                ds_list_add(created, inst2);
                idx++;
            }
        }
        return created;
    }

    ds_list_destroy(created);
    return noone;
}