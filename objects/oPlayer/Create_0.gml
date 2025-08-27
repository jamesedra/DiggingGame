//init
window_set_size(1920, 1080)
window_set_fullscreen(true)

//stat
hp = 3
invuln = 0

//movement
xVelocity = 0.0
yVelocity = 0.0
xVelocityMax = 2.0
yVelocityMax = 4.0
xAccel = 0.2
yAccel = 0.1
xDeAccel = 0.2
canDoubleJump = true
releasedJump = true

//controller
last_hover = noone;
highlight_radius = 25; // tweak
// mining (hold) config
mine_target      = noone;
mine_elapsed_us  = 0;

start_x = x;
start_y = y;

//points
points = 0
global.input_locked = false;

//health GUI
// --- HEART HUD (3 max, no halves) ---
hp = clamp(hp, 0, 3);

spr_heart_full  = sHeart_Full;   
spr_heart_empty = sHeart_Empty; 

hud_margin_top   = 24;   // px from top
hud_margin_right = 24;   // px from right
hud_spacing_px   = 6;    // px between hearts
hud_scale_factor = 4.0;  // extra scale multiplier if you want bigger/smaller
