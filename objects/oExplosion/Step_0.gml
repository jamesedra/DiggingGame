if (!active) {
    if (start_delay > 0) { start_delay--; exit; }
    active = true;
    image_index = 0;
    image_speed = play_speed;
    // optional: audio_play_sound(snd_explosion, 1, false);
}