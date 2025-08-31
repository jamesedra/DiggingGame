// freeze controls
global.paused = true;

// assets (swap to your win UI sprites)
spr_panel  = sMenu_Win;
spr_button = sButton_Death;

// base scalars
panel_scale_base       = 10.0;
button_scale_base      = 8.0;
title_text_scale_base  = 1.4;
button_text_scale_base = 0.4;

spacing_px = 24;
anim = 0;

title    = "Surfaced!";
btn_text = "Again?";

// Y offsets in design pixels (1920x1080 baseline)
title_offset_y_base       = -35;
button_offset_y_base      = 20;
button_text_offset_y_base = 0;

// optional callback
on_confirm = noone;

//make UI invis
playerInstance.visible = false

// --- STATS CONFIG (all tweakable) ---
stats_show               = true;
stats_rect_w_base        = 400;   // stats box width  @ scale 1
stats_rect_h_base        = 300;   // stats box height @ scale 1
stats_offset_y_base      = -230;    // pushes stats box down from the title
stats_pad_base           = 12;    // inner padding
stats_row_gap_base       = 35;     // extra vertical gap between lines
stats_text_scale_base    = 0.42;  // stats text scale
stats_bg_color           = make_color_rgb(0,0,0);
stats_bg_alpha           = 0.0;

// --- STATS SCALING OPTIONS ---
stats_scale_with_panel       = false; // false = use GUI scale (recommended), true = follow panel size
stats_auto_height            = true;  // grow to fit lines
stats_min_gap_to_button_base = 12;    // "design px" gap above button (pre-scale)

// --- SCORE LINE OPTIONS ---
score_text_scale_mult_base = 1.4;                       // bigger than other lines
score_text_color           = make_color_rgb(255,215,0); // gold-ish; use c_yellow if you want
score_gap_top_base         = 100;                        // min gap between top lines and bottom score (design px)

// keep the stats box a minimum gap above the button? (turn off to stop coupling)
stats_keep_gap_from_button = false; // was implicitly "true" before

audio_play_sound(Success_1, 0, false)