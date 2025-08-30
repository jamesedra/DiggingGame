// Alarm[0] of oExplosionSpawner
// create the real explosion now (layer fallback -> depth)
var obj = spawn_obj;          // object_index to create (e.g., oExplosion)
var sx  = spawn_x;
var sy  = spawn_y;
var owner = spawn_owner;     // optional owner/player reference
var extra = spawn_extra;     // optional ds_map/struct for extra init fields

// decide layer vs depth
var inst;
if (is_string(spawn_layer) && layer_get_id(spawn_layer) != -1) {
    inst = instance_create_layer(sx, sy, spawn_layer, obj);
} else {
    var d = (is_real(spawn_depth) ? spawn_depth : depth);
    inst = instance_create_depth(sx, sy, d, obj);
}

// assign extras safely after creation
if (inst != noone) {
    // pass owner ref so explosion can award points later
    if (owner != noone) inst.owner_player = owner;

    // if we need to pass several initialization params, use a ds_map or struct
    if (!is_undefined(extra) && extra != noone) {
        // copy/map keys -> instance variables
        if (is_dsmap(extra)) {
            var keys = ds_map_keys(extra);
            var kcnt = ds_list_size(keys);
            for (var i = 0; i < kcnt; ++i) {
                var k = ds_list_find_value(keys, i);
                inst[? k] = ds_map_find_value(extra, k);
            }
            ds_list_destroy(keys);
        } else if (is_array(extra)) {
            // if you prefer arrays: user-defined handling
            // (leave it or implement as needed)
        } else if (is_struct(extra)) {
            // copy fields from struct (GameMaker 2.3+)
            var names = struct_keys(extra);
            for (var i=0; i<array_length(names); ++i) {
                var n = names[i];
                inst[n] = extra[n];
            }
        }
    }
}
instance_destroy(); // spawner done
