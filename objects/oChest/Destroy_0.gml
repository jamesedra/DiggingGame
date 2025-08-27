var count = irandom_range(22, 40);

// spawn biscuits *before* this instance actually vanishes from the room graph
spawn_biscuit_burst(x, y, count);

// juice: little poof sound
// audio_play_sound(snd_biscuit_pop, 1, false);
