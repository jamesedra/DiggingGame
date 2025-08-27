// --- world -> GUI conversion
var vx = camera_get_view_x(cam);
var vy = camera_get_view_y(cam);
var vw = camera_get_view_width(cam);
var vh = camera_get_view_height(cam);
var gw = display_get_gui_width();
var gh = display_get_gui_height();

var sx = (x - vx) * (gw / vw);
var sy = (y - vy) * (gh / vh);

// --- easing
var u = clamp(t, 0, 1);
var eRise  = 1 - power(1 - u, 3);     // outCubic for rise
var eScale = 1 - power(1 - u, 2);     // outQuad for scale
var yoff   = -rise_gui * eRise;
var scl    = lerp(scale0, scale1, eScale);
var a      = 1 - u;                    // fade out

var txt = "+" + string(amount);

if (amount < 250)
{
	scl *= 0.25
}

// shadow
draw_set_alpha(a * 0.6);
draw_set_color(col_shadow);
draw_text_transformed(sx + 2, sy + 2 + yoff, txt, scl, scl, 0);

// main
draw_set_alpha(a);
draw_set_color(col_main);
draw_text_transformed(sx, sy + yoff, txt, scl, scl, 0);

// restore
draw_set_alpha(1);
