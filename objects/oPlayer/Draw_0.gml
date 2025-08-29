/// Draw
draw_self(); // keep normal sprite rendering

if (debug_attack_hitbox && attack_dbg_show > 0) {
    // translucent fill
    draw_set_alpha(0.25);
    draw_set_color(attack_dbg_color);
    draw_rectangle(attack_dbg_x1, attack_dbg_y1, attack_dbg_x2, attack_dbg_y2, false);

    // crisp outline
    draw_set_alpha(1);
    draw_set_color(attack_dbg_color);
    draw_rectangle(attack_dbg_x1, attack_dbg_y1, attack_dbg_x2, attack_dbg_y2, true);

    // optional center marker
    var cx = (attack_dbg_x1 + attack_dbg_x2) * 0.5;
    var cy = (attack_dbg_y1 + attack_dbg_y2) * 0.5;
    draw_line(cx - 4, cy, cx + 4, cy);
    draw_line(cx, cy - 4, cx, cy + 4);

    // fade quickly
    attack_dbg_show -= 1;
}
