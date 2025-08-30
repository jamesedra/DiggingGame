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
gib_pieces = 6; 

// HEALTH / HURT STATE
hit_stun_max  = 12;   // frames of stun/iframes after a hit
hurt_timer    = 0;    // counts down when hurt

// KNOCKBACK
kb_force_y    = 4;    // vertical pop when hit
kbx           = 0;    // current horizontal knockback velocity

// because I can't find why it spawns on non zones

if (object_exists(oBlock) && place_meeting(x, y, oBlock)) {
    instance_destroy();
    exit;
}
alarm[0] = 1;