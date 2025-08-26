// draw "GET OUT" when countdown finishes
var dt_ms = delta_time / 1000;          // µs -> ms
var dt    = delta_time / 1000000;       // µs -> s
if (!running) {
    var msg = "LAVA IS RISING!";
    var cx  = display_get_gui_width() * 0.5;
    var cy  = margin_y;
    var o   = outline_px;
    var red = make_color_rgb(255, 40, 40);

    // --- UPDATE PULSE VALUES WHILE NOT RUNNING ---
    // one-shot pop decays toward 0
    pulse_t = max(0, pulse_t - pulse_decay * dt);

    // gentle looping "breathe" pulse (0..1 -> sin -> 0..1)
    out_phase += (2 * pi) * out_speed_hz * dt;
    if (out_phase > 2 * pi) out_phase -= 2 * pi;
    var breathe = 0.5 + 0.5 * sin(out_phase); // 0..1

    // final scale: base + pop + breathe
    var s = out_base
          + out_pop_amp     * sqr(pulse_t)     // snappy pop that eases out
          + out_breathe_amp * breathe;         // subtle ongoing pulse

    if (has_font) draw_set_font(Arcade72);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);

    // shadow
    draw_set_alpha(0.5);
    draw_set_color(col_shadow);
    draw_text_transformed_color(cx + shadow_ofs, cy + shadow_ofs, msg, s, s, 0,
        col_shadow, col_shadow, col_shadow, col_shadow, 1);

    // 8-dir outline
    draw_set_alpha(1);
    draw_set_color(col_outline);
    draw_text_transformed_color(cx-o, cy,   msg, s,s,0, col_outline,col_outline,col_outline,col_outline,1);
    draw_text_transformed_color(cx+o, cy,   msg, s,s,0, col_outline,col_outline,col_outline,col_outline,1);
    draw_text_transformed_color(cx,   cy-o, msg, s,s,0, col_outline,col_outline,col_outline,col_outline,1);
    draw_text_transformed_color(cx,   cy+o, msg, s,s,0, col_outline,col_outline,col_outline,col_outline,1);
    draw_text_transformed_color(cx-o, cy-o, msg, s,s,0, col_outline,col_outline,col_outline,col_outline,1);
    draw_text_transformed_color(cx+o, cy-o, msg, s,s,0, col_outline,col_outline,col_outline,col_outline,1);
    draw_text_transformed_color(cx-o, cy+o, msg, s,s,0, col_outline,col_outline,col_outline,col_outline,1);
    draw_text_transformed_color(cx+o, cy+o, msg, s,s,0, col_outline,col_outline,col_outline,col_outline,1);

    // main red text
    draw_set_color(red);
    draw_text_transformed_color(cx, cy, msg, s, s, 0, red, red, red, red, 1);

    exit;
}


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
