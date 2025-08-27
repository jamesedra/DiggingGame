// oTryAgainModal.Draw GUI
var gw = display_get_gui_width();
var gh = display_get_gui_height();
var cx = gw * 0.5;
var cy = gh * 0.5;

// Backdrop
draw_set_alpha(0.6);
draw_set_color(c_black);
draw_rectangle(0, 0, gw, gh, false);

// Panel (pop-in)
var s  = 0.85 + (1 - power(1 - anim, 3)) * 0.15;
var pw = panel_w * s;
var ph = panel_h * s;

var px1 = cx - pw * 0.5;
var py1 = cy - ph * 0.5;
var px2 = cx + pw * 0.5;
var py2 = cy + ph * 0.5;

draw_set_alpha(1);
draw_set_color(make_color_rgb(30,30,30));
draw_roundrect(px1, py1, px2, py2, false);

draw_set_color(make_color_rgb(60,60,60));
draw_roundrect(px1, py1, px2, py2, true);

// Title scales with title_scale (and pop-in s)
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_text_transformed(cx, py1 + 48 * s, title, title_scale * s, title_scale * s, 0);

// Button rect: **fixed size**
var bx1 = cx - (btn_w * 0.5);
var by1 = py2 - btn_h - 24 * s; // keep eased spacing
var bx2 = bx1 + btn_w;
var by2 = by1 + btn_h;

// Hover
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
var hover = (mx >= bx1 && mx <= bx2 && my >= by1 && my <= by2);

// Button draw
draw_set_color(hover ? make_color_rgb(255,140,0) : make_color_rgb(255,120,0));
draw_roundrect(bx1, by1, bx2, by2, false);

// Button label: **only text scales with btn_scale** (and pop-in s)
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text_transformed(cx, by1 + btn_h * 0.5, btn_text, btn_scale * s, btn_scale * s, 0);

// restore
draw_set_halign(fa_left);
draw_set_valign(fa_top);
