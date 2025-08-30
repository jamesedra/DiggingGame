// --- only play SFX if we're on camera ---
var cam = view_camera[0];                     // assuming viewport 0
var vx  = camera_get_view_x(cam);
var vy  = camera_get_view_y(cam);
var vw  = camera_get_view_width(cam);
var vh  = camera_get_view_height(cam);

// small padding so edge cases still play
var margin = 32;

var on_camera =
    (bbox_right  >= vx - margin) &&
    (bbox_left   <= vx + vw + margin) &&
    (bbox_bottom >= vy - margin) &&
    (bbox_top    <= vy + vh + margin);

if (on_camera) {
	
	// spawn the visuals no matter what
	spawn_block_gibs(5);

    audio_play_sound(breakSound, 0, false, 1.0);
    if (secondaryBreakSound != noone) {
        audio_play_sound(secondaryBreakSound, 0, false, 1.0);
    }
}
