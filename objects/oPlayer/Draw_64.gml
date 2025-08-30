if (mine_target != noone && mouse_check_button(mb_left)) {
    var t = clamp(mine_target.mine_progress_us / max(1, mine_target.mine_time_us), 0, 1);
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
var depthText = "Depth: " + string(y + 9.6);
draw_text_transformed(10,30,depthText, 0.25,0.25,0)

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

// --- GUI sizing (you already compute this elsewhere; safe to duplicate) ---
var base_w = 1920, base_h = 1080;
var gw = display_get_gui_width();
var gh = display_get_gui_height();
var ui_scale = min(gw / base_w, gh / base_h) * 0.5;

// --- scaled dims/pos ---
var bar_x = depthbar_x_gui * ui_scale;
var bar_y = depthbar_y_gui * ui_scale;
var bar_h = depthbar_h_gui * ui_scale;
var bar_w = depthbar_w_gui * ui_scale;
var pad   = depthbar_pad_gui * ui_scale;

// --- normalize depth: 0 at top, 1 at bottom ---
var t = clamp(y / max(1, room_height), 0, 1);

// --- marker y along the bar ---
var mark_y = bar_y + t * bar_h;
var mark_r = max(3, 5 * ui_scale); // marker radius if using circle

// --- panel backdrop ---
draw_set_alpha(0.55);
draw_set_color(make_color_rgb(10,12,16));
draw_roundrect(bar_x - pad, bar_y - pad, bar_x + bar_w + pad, bar_y + bar_h + pad, false);

// --- bar background ---
draw_set_alpha(1);
draw_set_color(make_color_rgb(35,38,46));
draw_rectangle(bar_x, bar_y, bar_x + bar_w, bar_y + bar_h, false);

// --- LAVA FILL (bottom-up) ---
// Get the current lava surface in world Y (fallback: off-screen bottom if none)
var lava_yw = room_height + 999999;
if (instance_exists(oLava)) {
    var _lava = instance_find(oLava, 0);
    if (_lava != noone) lava_yw = _lava.surface_y;
}

// Normalize lava to 0..1 (0=top, 1=bottom), then map to bar space
var lava_t     = clamp(lava_yw / max(1, room_height), 0, 1);
var lava_gui_y = bar_y + lava_t * bar_h;

// Fill from lava surface to the bottom of the bar (orange)
draw_set_alpha(0.85);
draw_set_color(make_color_rgb(255, 120, 40));
draw_rectangle(bar_x, lava_gui_y, bar_x + bar_w, bar_y + bar_h, false);

// bright “cap” line at the lava surface
draw_set_alpha(1);
draw_set_color(make_color_rgb(255, 180, 60));
draw_line(bar_x, lava_gui_y, bar_x + bar_w, lava_gui_y);

// --- blinking triangle pointer when lava is rising ---
if (instance_exists(lavaInstance) && lavaInstance.rising) {
    var blink_on = ((current_time div 300) mod 2) == 0; // ~3.3 Hz blink
    if (blink_on) {
        // scalar you can control globally; default=1 keeps current dimensions
        var tri_scale = 2;
        if (variable_global_exists("lava_tri_scale")) tri_scale = global.lava_tri_scale;

        var base_tri_w = max(8, 12 * ui_scale);
        var base_tri_h = max(6, 10 * ui_scale);
        var tri_w = base_tri_w * tri_scale;
        var tri_h = base_tri_h * tri_scale;

        var x_tip = 3.5 + bar_x + bar_w + 3 * ui_scale; // tip touches near the bar, points LEFT
        var y_mid = lava_gui_y;                   // align with lava surface line
        var x_base = x_tip + tri_w;
        var y_top  = y_mid - tri_h * 0.5;
        var y_bot  = y_mid + tri_h * 0.5;

        draw_set_alpha(1);
        draw_set_color(make_color_rgb(255, 0, 0));
        draw_triangle(x_tip, y_mid, x_base, y_top, x_base, y_bot, false);
    }
}

// (Restore whatever alpha/color you want for next draws)
draw_set_alpha(1);
draw_set_color(c_white);


// --- fill from TOP down to marker (optional visual) ---
draw_set_color(make_color_rgb(90,120,180)); // “progress” fill color
draw_rectangle(bar_x, bar_y, bar_x + bar_w, mark_y, false);

// --- ticks (0, 25, 50, 75, 100%) ---
draw_set_color(make_color_rgb(180,180,190));
for (var i = 0; i <= 4; i++) {
    var ty = bar_y + (bar_h * (i / 4));
    draw_line(bar_x - 4*ui_scale, ty, bar_x + bar_w + 4*ui_scale, ty);
}
// labels (0 at top, room_height at bottom)
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// --- marker/icon ---
if (depth_icon_sprite != -1) {
    var sc = 0.5 * ui_scale;
    draw_sprite_ext(depth_icon_sprite, 0, bar_x + bar_w * 0.5, mark_y, depthicon_scale_mult, depthicon_scale_mult, 0, c_white, 1);
} else {
    draw_set_color(c_yellow);
    draw_circle(bar_x + bar_w * 0.5, mark_y, mark_r, false);
}

// restore defaults (optional)
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);
