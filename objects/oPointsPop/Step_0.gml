// oFloatText.Step
if (t == 0)
{
    // Only play if we're on-screen
    var cam = view_camera[0];
    var vx  = camera_get_view_x(cam);
    var vy  = camera_get_view_y(cam);
    var vw  = camera_get_view_width(cam);
    var vh  = camera_get_view_height(cam);

    var on_screen = (x >= vx) && (x <= vx + vw) && (y >= vy) && (y <= vy + vh);

    if (on_screen && amount >= 100)
    {
        if (is_critical)
        {
            audio_play_sound(Fruit_Collect_3, 0, false, 1.0);
        }
        else
        {
            audio_play_sound(Fruit_Collect_2, 0, false, 1.0);
        }
    }
}

t += (delta_time / 1_000_000) / lifetime; // delta_time is in microseconds
if (t >= 1) instance_destroy();
