// ---------- CONFIG ----------
// Fonts
menu_font_title = Arcade72;
menu_font_btn   = Arcade24;

// Optional fullscreen
window_set_fullscreen(true);

// GUI baseline
base_w = 1920;
base_h = 1080;

// Title
title_text  = "DIG! DIG! DIG!";
title_scale = 1.2;

// Sprites
spr_panel  = sMenu_Win; 
spr_button = sButton_Death;

// Optional GUI background sprite (fullscreen in GUI space)
spr_background = sCave3;

// ---- Controls ----
btn_scale                  = 8.0;   // button size (keeps aspect)
btn_gap_base               = 5;     // edge-to-edge gap between buttons (design px)
stack_center_offset_y_base = 80;    // shift the 3-button stack up/down (+down)

// Panel size controls (keeps aspect)
panel_width_base = 1000;    // panel width at scale 1 (design px)
panel_scale      = 1.0;     // multiplier on that width

// Label look
btn_label_color  = c_white;
btn_label_shadow = true;
btn_shadow_color = make_color_rgb(0,0,0);
btn_shadow_px    = 2;
label_scale      = 1.0;

// Back button scale (uniform; keeps sprite aspect)
back_btn_scale   = 0.7;

// Controls sheet scale (uniform). 1.0 = fit inside panel; <1 smaller; >1 can exceed panel.
controls_scale   = 1.0;

// Always 3 buttons
buttons = [
    { label: "Play",      cb: function(){ room_goto(World); } },
    { label: "Controls",  cb: method(self, function(){ self.show_controls = true; }) },
    { label: "Quit",      cb: function(){ game_end(); } }
];

// ---------- STATE ----------
sel = 0;

// track whether selection should be shown (keyboard nav)
kb_nav = false;

// controls overlay state & back-button rect
show_controls = false;
back_x1 = 0; back_y1 = 0; back_x2 = 0; back_y2 = 0;

// cached controls sprite rect (aspect-correct)
_ctrl_x = 0; _ctrl_y = 0; _ctrl_w = 0; _ctrl_h = 0;

// Pre-alloc rects & cached layout
bx1 = [0,0,0];
by1 = [0,0,0];
bx2 = [0,0,0];
by2 = [0,0,0];

_calc_bw = 0; _calc_bh = 0; _calc_gap = 0; _stack_cy = 0;
_panel_x = 0; _panel_y = 0; _panel_w = 0; _panel_h = 0;

// Cached GUI metrics
gw = display_get_gui_width();
gh = display_get_gui_height();
ui = min(gw / base_w, gh / base_h);
cx = gw * 0.5;
cy = gh * 0.5;
