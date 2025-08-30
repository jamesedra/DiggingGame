// movement
hsp = 0
dir      = choose(-1,1); // start left or right
image_xscale = dir;

// gravity
grav   = 0.4;
vsp    = 0;
vsp_max = 12;            // terminal fall speed

//kb
kb_mult = 3.0
frameCount = 0

// gibs
gib_pieces = 4; 

// HEALTH / HURT STATE
hit_stun_max  = 12;   // frames of stun/iframes after a hit
hurt_timer    = 0;    // counts down when hurt

// KNOCKBACK
kb_force_y    = 4;    // vertical pop when hit
kbx           = 0;    // current horizontal knockback velocity

// because I can't find why it spawns on non zones
// INSTANT PUSH-OUT if spawned overlapping a block
if (place_meeting(x, y, oBlock)) {
    var max_push = 64;
    var best = max_push + 1;
    var dx = 0, dy = 0, d = 0;

    d = 0; while (d <= max_push && place_meeting(x + d, y, oBlock)) d++; if (d < best) { best = d; dx =  d; dy =  0; }
    d = 0; while (d <= max_push && place_meeting(x - d, y, oBlock)) d++; if (d < best) { best = d; dx = -d; dy =  0; }
    d = 0; while (d <= max_push && place_meeting(x, y + d, oBlock)) d++; if (d < best) { best = d; dx =  0; dy =  d; }
    d = 0; while (d <= max_push && place_meeting(x, y - d, oBlock)) d++; if (d < best) { best = d; dx =  0; dy = -d; }

    x += dx; 
    y += dy;
}
alarm[0] = 1;
