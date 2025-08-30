/// oBiscuitGib.Create
// if the spawner doesn't override these, we'll randomize sane defaults
life_s   = choose(0.55, 0.65, 0.75, 0.9); // seconds to live
t        = 0;                              // 0..1 normalized lifetime


sprite_index = choose(sBiscuit0, sBiscuit1, sBiscuit2)


// motion
var spd  = random_range(2.2, 4.0);
var dir  = irandom(359);
vx       = lengthdir_x(spd, dir);
vy       = lengthdir_y(spd, dir) - random_range(0.6, 1.6); // upward bias
grav     = 0.18;     // pull down per step (tuned w/ dt below)
drag     = 0.015;    // mild air drag

// look
image_angle = irandom(359);
spin_deg    = irandom_range(-10, 10);
scale0      = random_range(0.85, 1.15);
scale1      = scale0 * 0.6; // settles a bit
alpha0      = 1.0;
alpha1      = 0.0;

// (sprite_index is set by spawner)
image_speed = 0; // use rotation, not sprite anim


