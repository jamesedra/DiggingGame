// --- oLava.Step ---
var dt = delta_time / 1_000_000; // seconds

// A) Constant rise
if (rising)
{
	rise_speed = min(rise_speed + rise_accel * dt, rise_speed_max);
	surface_y -= rise_speed * dt; // up is negative Y in GM
}


// 2) Kill on touch (if any player's feet are under the surface)
with (oPlayer) {
    if (bbox_bottom > other.surface_y) {
    }
}
