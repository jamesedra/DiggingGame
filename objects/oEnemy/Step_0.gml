if (global.input_locked == true) exit;

frameCount++

// apply gravity
vsp = clamp(vsp + grav, -99, vsp_max);

// desired horizontal movement
hsp = walk_spd * dir;

// --- horizontal collision + wall flip ---
if (place_meeting(x + hsp, y, oBlock)) {
    // slide up to the wall
    while (!place_meeting(x + sign(hsp), y, oBlock)) {
        x += sign(hsp);
    }
    // bounce the patrol direction
    dir *= -1;
    image_xscale = dir;
    hsp = 0;
}

// --- vertical collision (ground / ceiling) ---
if (place_meeting(x, y + vsp, oBlock)) {
    while (!place_meeting(x, y + sign(vsp), oBlock)) {
        y += sign(vsp);
    }
    vsp = 0;
}


// move
x += hsp;
y += vsp;