if (!audio_is_playing(AugustUltraAmbience)) {
    audio_play_sound(AugustUltraAmbience, 0, true)
}

if (audio_is_playing(Jazzy)) {
    audio_stop_sound(Jazzy)
}
