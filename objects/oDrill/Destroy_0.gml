

var roffs = radial_offsets(explosion_count, explosion_radius, 0, explosion_jitter); // jitter 6 degrees
var ex = spawn_explosions_from_offsets(x, y, roffs, "Instances");

var cp = carried_player;

// attach owner info and any extra data to each explosion instance
if (ex != noone) {
	audio_play_sound(Explosion_3, 0, false)
    var n = ds_list_size(ex);
    for (var i = 0; i < n; ++i) {
        var e = ds_list_find_value(ex, i);
        if (instance_exists(e)) {
            e.owner_player = cp;       // assign reference
        }
    }
    ds_list_destroy(ex);
}
