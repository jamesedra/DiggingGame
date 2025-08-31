function random_range(a, b) { return a + random((b - a)); }
function irandom_range(a, b) { return a + irandom(b - a); }
function random_choice(a, b) { return (irandom(1) == 0) ? a : b; }
spawn_timer     = 0;
spawn_interval  = 120;
spawn_jitter    = 0.6;

cloud_y           = -128;           // baseline y (you can set to any fixed height)
cloud_y_jitter    = -16;

min_speed = 0.15;
max_speed = 0.35;

min_scale = 10.0;
max_scale = 20.0;

min_alpha = 0.90;
max_alpha = 1.0;

initial_cloud_count = 6;
for (var i = 0; i < initial_cloud_count; ++i) {
    var sx = irandom_range(-10, room_width + 10); // includes -10 outside the room
    var sy = cloud_y + random_range(-cloud_y_jitter, cloud_y_jitter);

    // If you're using layers, ensure layer name exists. Alternative: instance_create_depth
    var cl = instance_create_depth(sx, sy, 10000, oCloud); // safe alternative to instance_create_layer
    cl.hspd = -random_range(min_speed, max_speed) * (random_choice(0.5, 1.0));
    cl.cloud_scale = random_range(min_scale, max_scale);
    cl.cloud_alpha = random_range(min_alpha, max_alpha);
    cl.cloud_depth = 10000 + irandom(2000);
    cl.base_y = sy;
}
