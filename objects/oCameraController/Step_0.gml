var cam = view_get_camera(0);
if (cam == -1) exit;

var w = camera_get_view_width(cam);
var h = camera_get_view_height(cam);

// Target: center on player
var tx = oPlayer.x - w * 0.5;
var ty = oPlayer.y - h * 0.5;

// Current camera position
var cx = camera_get_view_x(cam);
var cy = camera_get_view_y(cam);

// Smooth toward target (0..1; higher = snappier)
var s = 0.10;
cx = lerp(cx, tx, s);
cy = lerp(cy, ty, s);

// --- Clamp X to [0, N - w] ---
var N = room_width;
cx = clamp(cx, 0, max(0, N - w));

camera_set_view_pos(cam, cx, cy);
