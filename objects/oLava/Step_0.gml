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
    if (bbox_bottom > other.surface_y - 12.5 && other.hitPlayer == false) 
	{
		audio_play_sound(Hit_1, 0, false)
		other.hitPlayer = true
		hp = 0
    }
}

// --- oLava.Step (append at end) ---
// Map nearest player's feet to a 0..1 FX intensity based on distance to lava
if (!variable_global_exists("lava_fx")) global.lava_fx = 0;

var closest_gap = 999999999; // "gap" = pixels the lava is below the player's feet
with (oPlayer) {
    var gap = other.surface_y - bbox_bottom; // >0 means lava is below the player
    if (gap < closest_gap) closest_gap = gap;
}

// Turn gap into intensity: 0 when far, 1 when right at the feet (or above)
var threshold_px = 1000; // how close lava must be to kick in strongly
var dist_px     = max(0, closest_gap);
var target_fx   = clamp(1 - (dist_px / threshold_px), 0, 1);

// Smooth it so it feels nice
global.lava_fx = lerp(global.lava_fx, target_fx, 0.30);
