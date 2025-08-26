var gui_w = display_get_gui_width();
var sec   = (count_up) ? floor(timer_ms / 1000) : floor(cd_remaining_ms / 1000);
var txt   = string(sec);

// scale with a little ease-out on the pulse
var s = scale_base + scale_pulse * sqr(pulse_t);

// center
var cx = gui_w * 0.5;
var cy = margin_y;


if (has_font) draw_set_font(Arcade72);

draw_set_halign(fa_center);
draw_set_valign(fa_top);

// drop shadow
draw_set_alpha(0.5);
draw_set_color(col_shadow);
draw_text_transformed_color(cx + shadow_ofs, cy + shadow_ofs, txt, s, s, 0, col_shadow, col_shadow, col_shadow, col_shadow, 1);

// 8-dir outline
draw_set_alpha(1);
draw_set_color(col_outline);
var o = outline_px;
draw_text_transformed_color(cx-o, cy,   txt, s,s,0, col_outline,col_outline,col_outline,col_outline,1);
draw_text_transformed_color(cx+o, cy,   txt, s,s,0, col_outline,col_outline,col_outline,col_outline,1);
draw_text_transformed_color(cx,   cy-o, txt, s,s,0, col_outline,col_outline,col_outline,col_outline,1);
draw_text_transformed_color(cx,   cy+o, txt, s,s,0, col_outline,col_outline,col_outline,col_outline,1);
draw_text_transformed_color(cx-o, cy-o, txt, s,s,0, col_outline,col_outline,col_outline,col_outline,1);
draw_text_transformed_color(cx+o, cy-o, txt, s,s,0, col_outline,col_outline,col_outline,col_outline,1);
draw_text_transformed_color(cx-o, cy+o, txt, s,s,0, col_outline,col_outline,col_outline,col_outline,1);
draw_text_transformed_color(cx+o, cy+o, txt, s,s,0, col_outline,col_outline,col_outline,col_outline,1);

// main text
draw_set_color(col_text);
draw_text_transformed_color(cx, cy, txt, s, s, 0, col_text, col_text, col_text, col_text, 1);
