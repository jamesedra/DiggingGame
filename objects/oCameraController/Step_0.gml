var cam = view_get_camera(0);
if (cam == -1) exit;

var w = camera_get_view_width(cam);
var h = camera_get_view_height(cam);

// Current camera position (used as fallback)
var cx = camera_get_view_x(cam);
var cy = camera_get_view_y(cam);

// Target: default to "stay where we are"
var tx = cx;
var ty = cy;

// If a player exists, follow it
if (instance_exists(oPlayer)) {
    // If you can have multiple players, pick one deterministically:
    var p = instance_find(oPlayer, 0); // or instance_nearest(cx + w*0.5, cy + h*0.5, oPlayer)
    if (p != noone) {
        tx = p.x - w * 0.5;
        ty = p.y - h * 0.5;
    }
}

// Smooth toward target (0..1; higher = snappier)
var s = 0.10;
cx = lerp(cx, tx, s);
cy = lerp(cy, ty, s);

// Clamp X (and optionally Y)
cx = clamp(cx, 0, max(0, room_width  - w));
// If you also want to clamp vertically, uncomment:
// cy = clamp(cy, 0, max(0, room_height - h));

camera_set_view_pos(cam, cx, cy);
