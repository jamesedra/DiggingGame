// oPauseModal.Draw GUI
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

// draw panel sprite stretched to panel rect
draw_set_alpha(1);
draw_sprite_stretched_ext(panel_spr, 0, px1, py1, pw, ph, c_white, 1);

// Title (text scales only)
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_text_transformed(cx, py1 + 52 * s, title, title_scale * s, title_scale * s, 0);

// Buttons (fixed rects) — compute same rects as in Step
var bw = btn_w;
var bh = btn_h;
var total_h = bh * 3 + gap_y * 2;
var group_top = cy + ph * 0.5 - total_h - margin * s;

var cont_x1 = cx - bw * 0.5;
var cont_y1 = group_top;

var rest_x1 = cx - bw * 0.5;
var rest_y1 = group_top + bh + gap_y;

var exit_x1 = cx - bw * 0.5;
var exit_y1 = group_top + (bh + gap_y) * 2;

// hover
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
var hover_cont = (mx >= cont_x1 && mx <= cont_x1 + bw && my >= cont_y1 && my <= cont_y1 + bh);
var hover_rest = (mx >= rest_x1 && mx <= rest_x1 + bw && my >= rest_y1 && my <= rest_y1 + bh);
var hover_exit = (mx >= exit_x1 && mx <= exit_x1 + bw && my >= exit_y1 && my <= exit_y1 + bh);

// tint colors (kept from your original hover behavior)
var colA = hover_cont ? make_color_rgb(255,140,0) : c_white;
var colB = hover_rest ? make_color_rgb(255,140,0) : c_white;
var colC = hover_exit ? make_color_rgb(255,140,0) : c_white;

// draw button sprites stretched to rects with tint
draw_sprite_stretched_ext(btn_spr, 0, cont_x1, cont_y1, bw, bh, colA, 1);
draw_sprite_stretched_ext(btn_spr, 0, rest_x1, rest_y1, bw, bh, colB, 1);
draw_sprite_stretched_ext(btn_spr, 0, exit_x1, exit_y1, bw, bh, colC, 1);

// labels (only text scales with btn_scale)
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
if (variable_global_exists("has_font") && has_font) draw_set_font(Arcade72);

draw_text_transformed(cx, cont_y1 + bh * 0.5, btnA_txt, btn_scale * s, btn_scale * s, 0);
draw_text_transformed(cx, rest_y1 + bh * 0.5, btnB_txt, btn_scale * s, btn_scale * s, 0);
draw_text_transformed(cx, exit_y1 + bh * 0.5, btnC_txt, btn_scale * s, btn_scale * s, 0);

// restore
draw_set_halign(fa_left);
draw_set_valign(fa_top);
