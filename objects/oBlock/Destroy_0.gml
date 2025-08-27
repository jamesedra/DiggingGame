if (variable_global_exists("World") && !is_undefined(global.World)) {
    // Prefer stored grid coords set at spawn; fall back to deriving from position
    var c = variable_instance_exists(id, "gcol") ? gcol : world_px_to_col(x);
    var r = variable_instance_exists(id, "grow") ? grow : world_py_to_row(y);
    world_on_tile_instance_destroyed(c, r);
}