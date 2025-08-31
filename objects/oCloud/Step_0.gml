x += hspd;

// smooth bobbing without accumulation
if (bob_amp != 0) {
    // use current_time for a stable global phase; scale to steps
    y = base_y + sin(current_time * 0.001 * bob_speed) * bob_amp;
} else {
    y = base_y;
}

// cleanup margin (small, since you spawn at -10)
var cleanup_margin = 32; // in pixels; adjust if sprites are huge
if (hspd < 0 && x < -cleanup_margin) instance_destroy();
if (hspd > 0 && x > room_width + cleanup_margin) instance_destroy();