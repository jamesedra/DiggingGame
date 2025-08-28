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

//draw depth
var depthText = "Depth: " + string(y);
draw_text_transformed(10,10,depthText, 0.25,0.25,0)

// --- HEART BAR: top-right, fill L→R (depletes from left) ---
hp = clamp(hp, 0, 3);

var gui_w    = display_get_gui_width();
var gui_h    = display_get_gui_height();
var hb_scale = min(gui_w/1920, gui_h/1080) * hud_scale_factor;

var heart_w = sprite_get_width(spr_heart_full)  * hb_scale;
var heart_h = sprite_get_height(spr_heart_full) * hb_scale;
var gap     = hud_spacing_px * hb_scale;

var count = 3;
var stride = heart_w + gap;

// Right anchor (bar hugs the right edge)
var x_rightmost = round(gui_w - hud_margin_right - heart_w);
var y_top       = round(hud_margin_top);

// Compute the **leftmost** heart x (so we can draw L→R but still right-anchored)
var x_leftmost  = x_rightmost - (count - 1) * stride;

// 1) draw empties left → right
var cur_x = x_leftmost;
for (var i = 0; i < count; ++i) {
    draw_sprite_ext(spr_heart_empty, 0, cur_x, y_top, hb_scale, hb_scale, 0, c_white, 1);
    cur_x = round(cur_x + stride);
}

// 2) overlay full hearts for current hp (left → right)
cur_x = x_leftmost;
for (var i = 0; i < hp; ++i) {
    draw_sprite_ext(spr_heart_full, 0, cur_x, y_top, hb_scale, hb_scale, 0, c_white, 1);
    cur_x = round(cur_x + stride);
}

