//init
window_set_size(1920, 1080)
window_set_fullscreen(true)

//stat
hp = 3
invuln = 0
show_debug_overlay(true);
//movement
xVelocity = 0.0
yVelocity = 0.0
xVelocityMax = 2.0
yVelocityMax = 4.0
xAccel = 0.2
yAccel = 0.1
jumpAccel = 0.15
xDeAccel = 0.2

// --- Jump (hold to jump higher) ---
jump_initial_speed = 2.0;   // initial upward kick (was 2)
jump_hold_time_max = 8;    // frames you can hold for extra height
jump_cut_speed     = 1.0;   // cap upward speed when released early (short hop)
isJumping = false;
jump_hold_timer = 0;


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
global.paused = false;

//health GUI
// --- HEART HUD (3 max, no halves) ---
hp = clamp(hp, 0, 3);

spr_heart_full  = sHeart_Full;   
spr_heart_empty = sHeart_Empty; 

hud_margin_top   = 24;   // px from top
hud_margin_right = 24;   // px from right
hud_spacing_px   = 6;    // px between hearts
hud_scale_factor = 4.0;  // extra scale multiplier if you want bigger/smaller

// drill carry related vars
is_carried     = false;   // true while being carried
carried_by     = noone;   // instance id of the carrier
_saved_yAccel  = undefined; // used to restore gravity-like accel

// DEPTH BAR CONFIG (GUI coordinates; will be scaled)
depthbar_x_gui   = 32;   // left padding from GUI edge
depthbar_y_gui   = 140;  // top padding
depthbar_h_gui   = 620;  // bar height at 1.0 scale
depthbar_w_gui   = 36;   // bar width at 1.0 scale
depthbar_pad_gui = 6;    // panel padding
depthicon_scale_mult = 1.0; // controls the ICON size only

depth_icon_sprite = sPlayer_Idle; // e.g., sDepthIcon

