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
