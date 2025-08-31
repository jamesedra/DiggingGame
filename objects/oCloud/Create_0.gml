// pick sprite
var pick = irandom(2);
if (pick == 0) sprite_index = sCloud;
else if (pick == 1) sprite_index = sCloud_1;
else sprite_index = sCloud_2;

image_speed = 0;
image_index = irandom(sprite_get_number(sprite_index) - 1);

// defaults (can be overridden by spawner)
if (!variable_instance_exists(id, "cloud_scale")) cloud_scale = random_range(0.85, 1.25);
image_xscale = image_yscale = cloud_scale;

if (!variable_instance_exists(id, "cloud_alpha")) cloud_alpha = random_range(0.45, 0.95);
image_alpha = cloud_alpha;

if (!variable_instance_exists(id, "hspd")) hspd = -random_range(0.2, 0.9);

// base_y prevents cumulative drift
base_y = y;
bob_amp = variable_instance_exists(id, "bob_amp") ? bob_amp : 0;
bob_speed = variable_instance_exists(id, "bob_speed") ? bob_speed : 0;

// depth: set if desired (avoid enormous margins unless you want)
if (!variable_instance_exists(id, "cloud_depth")) cloud_depth = 10000 + irandom(2000);
depth = cloud_depth;