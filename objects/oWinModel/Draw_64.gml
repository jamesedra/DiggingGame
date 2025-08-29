var gw = display_get_gui_width();
var gh = display_get_gui_height();
var cx = gw * 0.5;
var cy = gh * 0.5;

var ui_scale = min(gw/1920, gh/1080);
var s_pop = 0.85 + (1 - power(1 - clamp(anim,0,1), 3)) * 0.15;

var panel_s       = panel_scale_base       * ui_scale * s_pop;
var button_s      = button_scale_base      * ui_scale * s_pop;
var title_s       = title_text_scale_base  * ui_scale * s_pop;
var button_text_s = button_text_scale_base * ui_scale * s_pop;

// scaled offsets
var title_off_y  = round(title_offset_y_base       * panel_s);
var button_off_y = round(button_offset_y_base      * panel_s);
var label_off_y  = round(button_text_offset_y_base * button_s);

// --- Panel ---
var p_src_w = sprite_get_width(spr_panel);
var p_src_h = sprite_get_height(spr_panel);
var p_w = round(p_src_w * panel_s);
var p_h = round(p_src_h * panel_s);
var p_x = round(cx - p_w * 0.5);
var p_y = round(cy - p_h * 0.5);

draw_sprite_stretched_ext(spr_panel, 0, p_x, p_y, p_w, p_h, c_white, 1);

// --- Title ---
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_text_transformed(cx, p_y + round(48 * panel_s) + title_off_y, title, title_s, title_s, 0);

// --- Button rect ---
var b_src_w = sprite_get_width(spr_button);
var b_src_h = sprite_get_height(spr_button);
var b_w = round(b_src_w * button_s);
var b_h = round(b_src_h * button_s);
var gap = round(spacing_px * panel_s);

var b_x = round(cx - b_w * 0.5);
var b_y = round(p_y + p_h - b_h - gap + button_off_y);

// --- Hover/press states ---
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

var hover   = (mx >= b_x && mx <= b_x + b_w && my >= b_y && my <= b_y + b_h);
var pressed = hover && mouse_check_button(mb_left);

var sub = 0; if (hover) sub = 1; if (pressed) sub = 2;

if (sprite_get_number(spr_button) >= 3) {
    draw_sprite_stretched_ext(spr_button, sub, b_x, b_y, b_w, b_h, c_white, 1);
} else {
    var col;
    if (pressed)    col = make_color_rgb(255,140,0);
    else if (hover) col = make_color_rgb(255,200,80);
    else            col = c_white;
    draw_sprite_stretched_ext(spr_button, 0, b_x, b_y, b_w, b_h, col, 1);
}

// --- Button label ---
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text_transformed(b_x + b_w * 0.5, b_y + b_h * 0.5 + label_off_y, btn_text, button_text_s, button_text_s, 0);

// restore defaults
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// animate pop-in
var dt = delta_time * 0.000001;
anim = clamp(anim + dt * 8, 0, 1);
