// oFloatText.Draw GUI
// Camera → GUI conversion
var cam = view_camera[0];
var vx = camera_get_view_x(cam);
var vy = camera_get_view_y(cam);
var vw = camera_get_view_width(cam);
var vh = camera_get_view_height(cam);
var gw = display_get_gui_width();
var gh = display_get_gui_height();

var sx = (x - vx) * (gw / vw);
var sy = (y - vy) * (gh / vh);

// Easing
var u      = clamp(t, 0, 1);
var eRise  = 1 - power(1 - u, 3);   // outCubic for rise
var eScale = 1 - power(1 - u, 2);   // outQuad for scale
var yoff   = -rise_gui * eRise;
var scl    = lerp(scale0, scale1, eScale);
var a      = 1 - u;                 // fade out

var txt = "+" + string(amount);

// --- NEW: size based on amount out of 5000
// Map amount 0..5000 → multiplier 1.0..0.25 (same “<250” size = 0.25×)
var pct = clamp(0.25 + amount / 5000, 0, 1);
//var mul = lerp(1.0, 0.25, pct);
scl *= pct;
if (is_critical) scl *= 1.25
scl *= total_scale

// Shadow
draw_set_alpha(a * 0.6);
draw_set_color(col_shadow);
draw_text_transformed(sx + 2, sy + 2 + yoff, txt, scl, scl, 0);

// Main
draw_set_alpha(a);
if (!is_critical)
{
	draw_set_color(col_main);
}
else
{
	draw_set_color(choose(c_red, c_aqua, c_blue, c_green, c_lime, c_orange, c_purple, c_purple, c_yellow, c_white));
}


draw_text_transformed(sx, sy + yoff, txt, scl, scl, 0);

// Restore
draw_set_alpha(1);
