// Inherit the parent event
event_inherited();

// Check directly below our bottom edge (1px tall line)
var stgm = collision_rectangle(
    bbox_left,
    bbox_bottom + 1,
    bbox_right,
    bbox_bottom + 3,
    oStalagmite,
    false,  // precise
    true    // notme
);

if (stgm != noone) {
    // If your stalagmite has a custom break script, call it here instead
    with (stgm) {
        instance_destroy();
    }
}
