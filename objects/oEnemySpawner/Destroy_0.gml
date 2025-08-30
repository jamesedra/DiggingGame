// Inherit the parent event
event_inherited();

if (variable_instance_exists(id, "size_cache")) {
    ds_map_destroy(size_cache);
}