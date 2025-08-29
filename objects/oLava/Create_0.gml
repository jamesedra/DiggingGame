// --- oLava.Create ---
// Top edge (surface) of the lava, world Y. Start below the room:
surface_y =  300;

// Motion (pixels/second)
rising = false
rise_speed   = 24;    // constant rise
rise_accel   = 0;     // set >0 if you want it to speed up over time
rise_speed_max = 120; // clamp

// Visuals
spr_fill    = sLavaBody;    // tileable lava interior (set to your sprite)
spr_surface = sLavaSurface; // thin wavy top sprite (set to your sprite)
wave_amp    = 2;          // px
wave_speed  = 4;          // cycles/sec
scroll_x    = 16;         // px/sec for horizontal texture drift

// Camera cache for drawing only the visible area
cam = view_camera[0];
hitPlayer = false;