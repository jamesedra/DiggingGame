function format_time_ms(ms) {
    var total = max(0, floor(ms / 1000));
    var s = total mod 60;
    var m = (total div 60) mod 60;
    var h = total div 3600;

    if (h > 0) {
        return string(h) + ":" + string_format(m, 2, 0) + ":" + string_format(s, 2, 0);
    } else {
        return string(m) + ":" + string_format(s, 2, 0);
    }
}

function start_countdown(s) {
    cd_total_ms      = max(0, round(s * 1000));
    cd_remaining_ms  = cd_total_ms;
    last_sec         = -1;   // keep your pulse logic
    pulse_t          = 0;
    running          = true;
}