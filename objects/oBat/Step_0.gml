/// oEnemy_Fly : Step
event_inherited(); // parent handles hsp patrol + wall flip; vsp is 0 so vertical collide does nothing

// --- DRIFT y_home toward the nearest player ---
var p = instance_nearest(x, y, oPlayer);
if (instance_exists(p)) { // instance_nearest returns noone if none exist
    if (point_distance(x, y, p.x, p.y) <= drift_range) {
        var dy   = p.y - y_home;
        // smooth & speed-limited approach toward player’s Y:
        var step = clamp(dy * drift_gain, -drift_step_max, drift_step_max);
        y_home  += step;

        // (alt smoothing: y_home = lerp(y_home, p.y, drift_gain); ) // see note below
    }
}

// --- BOB around the drifting center ---
bob_phi += bob_spd;
var y_target = y_home + sin(bob_phi) * bob_amp;

// --- after computing y_target ---
var fly_vmax = 2.0; // px/frame vertical limit
mp_linear_step_object(x, y_target, fly_vmax, oBlock);

