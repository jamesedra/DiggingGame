var gw = display_get_gui_width();
var gh = display_get_gui_height();

var sw = sprite_get_width(splash);
var sh = sprite_get_height(splash);

// scale to COVER the screen
var s = max(gw / sw, gh / sh);

// use the current animated subimage
var sub = clamp(floor(image_index), 0, sprite_get_number(splash) - 1);

// fade out near the end (optional)
var alpha = 1;
var fade_time = 20;
if (counter > splash_duration - fade_time) alpha = max(0, (splash_duration - counter) / fade_time);

draw_sprite_ext(splash, sub, gw * 0.5, gh * 0.5, s, s, 0, c_white, alpha);