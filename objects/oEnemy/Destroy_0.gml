/// Spawn gibs using the enemy's current sprite + subimage
// Big pop on death
spawn_block_gibs_explosive(gib_pieces, 2.25); // try 1.0 (normal) to ~3.0 (wild)
// Optional extra crumbs:
spawn_biscuit_burst(x, y, 8);

audio_play_sound(Fruit_Collect_1, 0, false)
audio_play_sound(Block_Break_3, 0, false)

