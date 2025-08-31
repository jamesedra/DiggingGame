spawn_timer -= 1;
if (spawn_timer <= 0) {
    spawn_timer = spawn_interval * random_range(1 - spawn_jitter, 1 + spawn_jitter);

    var goRight = (irandom(1) == 0);
    var sx = goRight ? -10 : room_width + 10; // <-- spawn at -n / room_width+n exactly
    var sy = cloud_y + random_range(-cloud_y_jitter, cloud_y_jitter);

    var cl = instance_create_depth(sx, sy, 10000, oCloud);
    var sp = random_range(min_speed, max_speed);
    cl.hspd = goRight ? sp : -sp;

    cl.cloud_scale = random_range(min_scale, max_scale);
    cl.cloud_alpha = random_range(min_alpha, max_alpha);
    cl.cloud_depth = 10000 + irandom(2000);
    cl.base_y = sy;
    cl.bob_amp = cl.cloud_scale > 1.1 ? random_range(0.2, 0.9) : 0;
    cl.bob_speed = random_range(2, 10);
}

if (instance_number(oCloud) == 0) show_debug_message("No clouds exist!");
else {
    with (oCloud) {
        show_debug_message("Cloud @ " + string(x) + ", " + string(y) + " sprite:" + string(sprite_index));
    }
}