if (mine_target != noone && mouse_check_button(mb_left)) {
    var t = clamp(mine_elapsed_us / mine_time_us, 0, 1);
    var w = 48, hbar = 6;
    var sx = device_mouse_x_to_gui(0);
    var sy = device_mouse_y_to_gui(0) - 20;

    draw_set_alpha(1);
    draw_set_color(c_black);
    draw_rectangle(sx - w/2 - 1, sy - hbar/2 - 1, sx + w/2 + 1, sy + hbar/2 + 1, false);
    draw_set_color(c_yellow);
    draw_rectangle(sx - w/2, sy - hbar/2, sx - w/2 + w*t, sy + hbar/2, false);
}

