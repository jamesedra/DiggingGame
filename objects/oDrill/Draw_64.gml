if (!e_show) exit;

// --- world -> GUI coords for a point above the drill ---
var cam = view_camera[0];

var vx = camera_get_view_x(cam);
var vy = camera_get_view_y(cam);
var vw = camera_get_view_width(cam);
var vh = camera_get_view_height(cam);

var gw = display_get_gui_width();
var gh = display_get_gui_height();

// pick a world point just above the drill's top
var wx = x;
var wy = bbox_top - e_offset_y;

// convert to GUI
var gx = (wx - vx) * (gw / vw);
var gy = (wy - vy) * (gh / vh);

// snap to pixels so the outline doesn't shimmer
gx = round(gx);
gy = round(gy);

// --- draw the small 'E' in your style (no pulsing) ---
var msg = "E";
var has_font = font_exists(Arcade72); // or set true if you’re sure
if (has_font) draw_set_font(Arcade72);

// center horizontally, top vertically
draw_set_halign(fa_left); // we'll center by hand using measured width
draw_set_valign(fa_top);
var w_unscaled = string_width(msg);
var x_left = round(gx - (w_unscaled * e_scale) * 0.5);
var y_top  = gy;

var col_text    = make_color_rgb(255,255,255);
var col_outline = make_color_rgb(20,20,20);
var col_shadow  = make_color_rgb(0,0,0);
var shadow_ofs  = 2;
var o           = 2;

// shadow
draw_set_alpha(0.5);
draw_set_color(col_shadow);
draw_text_transformed_color(x_left + shadow_ofs, y_top + shadow_ofs, msg, e_scale, e_scale, 0,
    col_shadow, col_shadow, col_shadow, col_shadow, 1);

// 8-dir outline
draw_set_alpha(1);
draw_set_color(col_outline);
draw_text_transformed_color(x_left-o, y_top,   msg, e_scale,e_scale,0, col_outline,col_outline,col_outline,col_outline,1);
draw_text_transformed_color(x_left+o, y_top,   msg, e_scale,e_scale,0, col_outline,col_outline,col_outline,col_outline,1);
draw_text_transformed_color(x_left,   y_top-o, msg, e_scale,e_scale,0, col_outline,col_outline,col_outline,col_outline,1);
draw_text_transformed_color(x_left,   y_top+o, msg, e_scale,e_scale,0, col_outline,col_outline,col_outline,col_outline,1);
draw_text_transformed_color(x_left-o, y_top-o, msg, e_scale,e_scale,0, col_outline,col_outline,col_outline,col_outline,1);
draw_text_transformed_color(x_left+o, y_top-o, msg, e_scale,e_scale,0, col_outline,col_outline,col_outline,col_outline,1);
draw_text_transformed_color(x_left-o, y_top+o, msg, e_scale,e_scale,0, col_outline,col_outline,col_outline,col_outline,1);
draw_text_transformed_color(x_left+o, y_top+o, msg, e_scale,e_scale,0, col_outline,col_outline,col_outline,col_outline,1);

// main
draw_set_color(col_text);
draw_text_transformed_color(x_left, y_top, msg, e_scale, e_scale, 0, col_text, col_text, col_text, col_text, 1);
