// Timer mode (same as before)
count_up    = false;
count_down  = true;
cd_remaining_ms = 2 * 60 * 1000;
timer_ms = 0;
running = true;

// --- ARCADE HUD STYLE ---
margin_y     = 24;     // distance from top
outline_px   = 4;      // pixel outline thickness
shadow_ofs   = 6;      // drop shadow offset
col_text     = make_color_rgb(255, 240, 0); // arcade yellow
col_outline  = c_black;
col_shadow   = c_black;

// BIG size + pulse on each tick
scale_base   = 1.0;    // baseline size
scale_pulse  = 0.25;   // how much it pops each second
pulse_t      = 0.0;    // 0..1
pulse_decay  = 6.0;    // how fast the pop fades (per second)
last_sec     = -1;     // to detect new seconds

// pop/breathe settings for the GET OUT text
out_base        = 0.60;   // base scale
out_pop_amp     = 0.40;   // extra scale from the one-shot pop (0.4 = +40%)
out_breathe_amp = 0.05;   // gentle ongoing pulse amount (+/- 5%)
out_speed_hz    = 1.8;    // pulses per second
out_phase       = 0.0;    // phase accumulator (radians)

// (Optional) use your big arcade font resource if you have one:
has_font     = true;  

start_countdown(3); // ← e.g., 30s