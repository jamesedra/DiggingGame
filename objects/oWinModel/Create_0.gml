// freeze controls
global.paused = true;

// assets (swap to your win UI sprites)
spr_panel  = sMenu_Death;
spr_button = sButton_Death;

// base scalars
panel_scale_base       = 5.0;
button_scale_base      = 6.0;
title_text_scale_base  = 0.7;
button_text_scale_base = 0.4;

spacing_px = 24;
anim = 0;

title    = "You Win!";
btn_text = "Again?";

// Y offsets in design pixels (1920x1080 baseline)
title_offset_y_base       = -35;
button_offset_y_base      = 30;
button_text_offset_y_base = 0;

// optional callback
on_confirm = noone;
