if (global.paused) exit;
frameCount++;

// INSTANT PUSH-OUT safeguard in case we ever end up inside a block
if (place_meeting(x, y, oBlock)) {
    var max_push = 1024;
    var best = max_push + 1;
    var dx = 0, dy = 0, d = 0;

    d = 0; while (d <= max_push && place_meeting(x + d, y, oBlock)) d++; if (d < best) { best = d; dx =  d; dy =  0; }
    d = 0; while (d <= max_push && place_meeting(x - d, y, oBlock)) d++; if (d < best) { best = d; dx = -d; dy =  0; }
    d = 0; while (d <= max_push && place_meeting(x, y + d, oBlock)) d++; if (d < best) { best = d; dx =  0; dy =  d; }
    d = 0; while (d <= max_push && place_meeting(x, y - d, oBlock)) d++; if (d < best) { best = d; dx =  0; dy = -d; }

    x += dx; 
    y += dy;
}

// gravity always applies
vsp = clamp(vsp + grav, -99, vsp_max);

// === HURT STUN / FLASH ===
if (hurt_timer > 0) {
    hurt_timer--;
    image_blend = c_red;       // brief red flash while stunned
} else {
    image_blend = c_white;
}

// === CHOOSE HORIZONTAL INTENT ===
// When stunned: use knockback velocity (kbx)
// Otherwise: patrol using walk_spd * dir
var use_kb = (hurt_timer > 0);
var hsp = use_kb ? kbx : (walk_spd * dir);

// --- horizontal collision ---
if (place_meeting(x + hsp, y, oBlock)) {
    // slide to contact
    while (!place_meeting(x + sign(hsp), y, oBlock)) x += sign(hsp);
    // only flip patrol dir when NOT stunned
    if (!use_kb) {
        dir *= -1;
        image_xscale = dir;
    }
    hsp = 0;
}

// --- vertical collision ---
if (place_meeting(x, y + vsp, oBlock)) {
    while (!place_meeting(x, y + sign(vsp), oBlock)) y += sign(vsp);
    vsp = 0;
}

// move
x += hsp;
y += vsp;

// decay knockback over time
if (use_kb) {
    kbx *= 0.85;
    if (abs(kbx) < 0.1) kbx = 0;
}

// DIE if HP depleted (award points + popup here, once)
if (hp <= 0) {
    var p = instance_nearest(x, y, oPlayer);
    if (instance_exists(p)) {
        p.points += value;                 // uses your existing enemy 'value'
        var pop = instance_create_layer(x, y, "Splash", oPointsPop);
        pop.amount = value;
    }
    // optional: spawn gibs here if you have a function for it
    // spawn_enemy_gibs(gib_pieces);
    instance_destroy();
}