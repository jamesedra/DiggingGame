image_index  = 0;
image_speed  = 0;       // paused until we "arm" it
active       = false;   // not yet active

// Use variable_instance_exists to avoid reading undefined locals
if (!variable_instance_exists(id, "start_delay")) start_delay = 0;
if (!variable_instance_exists(id, "owner_player")) owner_player = noone;

play_speed   = 0.5; 