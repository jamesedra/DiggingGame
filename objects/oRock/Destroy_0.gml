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
    with (stgm) instance_destroy();
}

// === Break crystals that GROW OUT of THIS block (angle-aware) + award points ===
var CRYSTAL_PARENT = oCrystal;  // parent of all crystal variants

// GameMaker angles (0=right, 90=up, 180=left, 270=down)
// Adjust these if your crystal sprite's "forward" differs.
var ANG_RIGHT = 270;
var ANG_UP    = 0;
var ANG_LEFT  = 90;
var ANG_DOWN  = 180;

var ANG_TOL = 35;   // widen if your crystals aren't exact
var t_out  = 8;     // how far OUTSIDE the block edge to search
var t_in   = 2;     // how far INSIDE the block edge to search

var found = ds_list_create();

// --- TOP band (should point UP) ---
var tmp = ds_list_create();
collision_rectangle_list(bbox_left, bbox_top - t_out, bbox_right, bbox_top + t_in,
                         CRYSTAL_PARENT, false, true, tmp, false);
for (var i = 0; i < ds_list_size(tmp); i++) {
    var inst = tmp[| i];
    if (instance_exists(inst)) {
        var diff = angle_difference(inst.image_angle, ANG_UP);
        if (abs(diff) <= ANG_TOL) ds_list_add(found, inst);
    }
}
ds_list_destroy(tmp);

// --- BOTTOM band (should point DOWN) ---
tmp = ds_list_create();
collision_rectangle_list(bbox_left, bbox_bottom - t_in, bbox_right, bbox_bottom + t_out,
                         CRYSTAL_PARENT, false, true, tmp, false);
for (var i = 0; i < ds_list_size(tmp); i++) {
    var inst = tmp[| i];
    if (instance_exists(inst)) {
        var diff = angle_difference(inst.image_angle, ANG_DOWN);
        if (abs(diff) <= ANG_TOL) ds_list_add(found, inst);
    }
}
ds_list_destroy(tmp);

// --- LEFT band (should point LEFT) ---
tmp = ds_list_create();
collision_rectangle_list(bbox_left - t_out, bbox_top, bbox_left + t_in, bbox_bottom,
                         CRYSTAL_PARENT, false, true, tmp, false);
for (var i = 0; i < ds_list_size(tmp); i++) {
    var inst = tmp[| i];
    if (instance_exists(inst)) {
        var diff = angle_difference(inst.image_angle, ANG_LEFT);
        if (abs(diff) <= ANG_TOL) ds_list_add(found, inst);
    }
}
ds_list_destroy(tmp);

// --- RIGHT band (should point RIGHT) ---
tmp = ds_list_create();
collision_rectangle_list(bbox_right - t_in, bbox_top, bbox_right + t_out, bbox_bottom,
                         CRYSTAL_PARENT, false, true, tmp, false);
for (var i = 0; i < ds_list_size(tmp); i++) {
    var inst = tmp[| i];
    if (instance_exists(inst)) {
        var diff = angle_difference(inst.image_angle, ANG_RIGHT);
        if (abs(diff) <= ANG_TOL) ds_list_add(found, inst);
    }
}
ds_list_destroy(tmp);

// Deduplicate, award points to nearest player, then destroy
var seen = ds_map_create();
for (var k = 0; k < ds_list_size(found); k++) {
    var c = found[| k];
    if (instance_exists(c) && !ds_map_exists(seen, c)) {
        ds_map_add(seen, c, 1);

        // --- award points (uses crystal.value if present) ---
        var award = c.value * random_range(0.8,1.2);
		var crit = random_range(0,100) > 90
		if (crit) award *= 4

        if (award > 0) {
            var p = instance_nearest(c.x, c.y, oPlayer);
            if (instance_exists(p)) {
                p.points += award;
                var pop = instance_create_layer(c.x, c.y, "Splash", oPointsPop);
                pop.amount = award;
				pop.is_critical = crit
            }
        }

        with (c) instance_destroy();
    }
}
ds_map_destroy(seen);
ds_list_destroy(found);
// === END ===
