if (mine_target != noone && mouse_check_button(mb_left)) {
    var t = clamp(mine_elapsed_us / mine_target.mine_time_us, 0, 1);
    var w = 48, hbar = 6;
    var sx = device_mouse_x_to_gui(0);
    var sy = device_mouse_y_to_gui(0) - 20;

    draw_set_alpha(1);
    draw_set_color(c_black);
    draw_rectangle(sx - w/2 - 1, sy - hbar/2 - 1, sx + w/2 + 1, sy + hbar/2 + 1, false);
    draw_set_color(c_yellow);
    draw_rectangle(sx - w/2, sy - hbar/2, sx - w/2 + w*t, sy + hbar/2, false);
}


// --- UI scale (relative to a 1920x1080 design) ---
var base_w = 1920, base_h = 1080;
var gw = display_get_gui_width();
var gh = display_get_gui_height();

// keep aspect by using the smaller ratio
var ui_scale = min(gw / base_w, gh / base_h) * 0.5;

// --- centered "Points" label (scaled) ---
var cx = round(gw * 0.5);
var yy = 150;

var s = "Points: " + string(points);

// backdrop (scaled padding and measured text)
var pad_x = 10 * ui_scale, pad_y = 4 * ui_scale;
var tw = string_width(s) * ui_scale;
var th = string_height(s) * ui_scale;

draw_set_alpha(0.5);
draw_set_color(c_black);
draw_roundrect(cx - tw*0.5 - pad_x, yy - pad_y,
               cx + tw*0.5 + pad_x, yy + th + pad_y, false);

// text (scaled)
draw_set_alpha(1);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(c_white);
// scale the text itself:
draw_text_transformed(cx, yy, s, ui_scale, ui_scale, 0);

// restore (optional)
draw_set_halign(fa_left);
draw_set_valign(fa_top);