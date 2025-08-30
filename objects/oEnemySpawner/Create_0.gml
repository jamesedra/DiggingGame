// Inherit the parent event
event_inherited();

enemy_type        = select_enemy();
spawn_layer       = "World";   // layer name (replace with your layer id/name)
spawn_offset_x    = 0;
spawn_offset_y    = 0;

spawn_radius      = 256;
spawn_step        = 16;
spawn_attempts    = 200;
solid_obj         = oBlock;        // solids to check
current_enemy     = noone;
permanently_slain = false;

size_cache = ds_map_create();