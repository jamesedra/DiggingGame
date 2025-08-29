dt_ms = delta_time / 1000;          // microseconds -> ms
dt    = delta_time / 1000000;       // seconds


if (count_up && !global.paused) {
    timer_ms += dt_ms;
} else if (count_down && !global.paused) {
    cd_remaining_ms = max(0, cd_remaining_ms - dt_ms);
    if (cd_remaining_ms <= 0) {
        cd_remaining_ms = 0;
        running = false;
        pulse_t = 1.0;  // <-- trigger pop for "GET OUT!"
		//start lava rising
		lavaInstance.rising = true
		audio_stop_sound(AugustUltraAmbience)
		if (!audio_is_playing(Jazzy))
		audio_play_sound(Jazzy, 0, true)
    }
}

// detect whole-second tick for the pop
var sec_now = (count_up) ? floor(timer_ms / 1000) : floor(cd_remaining_ms / 1000);
if (sec_now != last_sec) {
    last_sec = sec_now;
    pulse_t  = 1.0;
}
pulse_t = max(0, pulse_t - pulse_decay * dt);
