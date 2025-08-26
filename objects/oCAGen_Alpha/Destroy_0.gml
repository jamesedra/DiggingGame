/// Destroy - cleanup debug instances
if (ds_exists(tile_instances, ds_type_grid)) {
    for (var gy=0; gy<worldH; gy++) for (var gx=0; gx<worldW; gx++) {
        var inst = ds_grid_get(tile_instances, gx, gy);
        if (inst != noone && instance_exists(inst)) instance_destroy(inst);
    }
    ds_grid_destroy(tile_instances);
}
