if (!debug_on) exit;
if (!view_enabled) exit;

var cam = view_camera[0];
world_debug_draw_zones_for_camera(cam);
