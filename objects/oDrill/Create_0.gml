//state = "idle";            // "idle", "active", "done"
//spr_idle = sDrill_Red;
//spr_active = sDrill_Red_Active;
sprite_index = spr_idle;

carried_player = noone;
carry_time = 0;
//carry_duration = 90;       // frames to carry (1.5s @60fps)
//carry_speed = -2;          // negative = move up
//carry_offset_y = -16;      // where player sits relative to drill

//// release tuning
//release_push_speed = 4;    // horizontal push on release (uses player's xVelocity)
//release_up_speed   = -4;   // vertical on release (negative = up)
//release_nudge      = -4;   // nudge added to Y when released (helps avoid ground overlap)

// prompt state
e_show = false;
e_offset_y = 14;   // how far above the drill to draw the 'E' (world pixels)
e_scale   = 0.4;   // smaller than your banner