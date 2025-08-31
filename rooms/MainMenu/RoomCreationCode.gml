audio_master_gain(0.5);

audio_stop_all()

if (!audio_is_playing(Jazzy)) {
    audio_play_sound(Jazzy, 0, true)
}