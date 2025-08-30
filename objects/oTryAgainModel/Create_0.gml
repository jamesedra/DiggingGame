// freeze controls
global.paused = true;

// assets
spr_panel  = sMenu_Death;
spr_button = sButton_Death;

// base scalars (tweak these)
panel_scale_base       = 5.0;  // panel sprite size
button_scale_base      = 5.0;  // button sprite size
title_text_scale_base  = 0.7;  // "YOU DIED!" / "Try again?"
button_text_scale_base = 0.4;  // button label

spacing_px = 24;               // gap between panel bottom and button (in px at scale 1)
anim = 0;                      // 0..1 pop-in
title    = "Try again?";
btn_text = "Go!";

// Y offsets in "design pixels" (1920×1080 baseline)

title_offset_y_base       = -35;  // moves the title text
button_offset_y_base      = 17;  // moves the whole button up/down
button_text_offset_y_base = 0;  // moves the label on the button
