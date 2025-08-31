// Only apply when actively carrying player and we still own them
if (owner_player != noone) {
    // sanity checks
    if (!instance_exists(owner_player)) exit;
    if (!instance_exists(other)) exit; // enemy already gone

    // read enemy value safely (default 0)
    var enemy_val = variable_instance_exists(other, "value") ? other.value : 0;

    // award points to the carried player (or global fallback)
    if (variable_instance_exists(owner_player, "points")) {
		var val = enemy_val * random_range(0.8,1.2)
        owner_player.points += val;
		
		// create points popup at enemy location (capture coords first)
	    var ex = other.x;
	    var ey = other.y;
	    var pop = instance_create_layer(ex, ey, "Splash", oPointsPop);
	    if (pop != noone) pop.amount = val;
    } else {
        if (!variable_global_exists("points")) global.points = 0;
        global.points += enemy_val;
    }

    // destroy the enemy (its Destroy event runs normally)
    with (other) {
        // run any local death VFX if you like, e.g. spawn_block_gibs() if defined
        instance_destroy();
    }
}