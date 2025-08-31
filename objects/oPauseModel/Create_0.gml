// oPauseModal.Create
global.paused = true; // freeze everything

title    = "PAUSED";
btnA_txt = "Continue";
btnB_txt = "Restart";
btnC_txt = "Exit"; // exit button label

panel_w = 460;
panel_h = 340;
btn_w   = 260;
btn_h   = 56;

anim = 0;           // 0..1 pop-in animation
title_scale = 0.8;  // text only
btn_scale   = 0.4;  // text only

gap_y   = 14;       // gap between the two buttons
margin  = 24;       // bottom margin inside panel

// NEW: sprites (rename to your resource names if needed)
panel_spr = sMenu_Pause;
btn_spr   = sButton_Death;
