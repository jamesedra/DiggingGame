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
