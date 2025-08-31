// Only apply when actively carrying player and we still own them
if (state == "active" && carried_player != noone) {
    // sanity checks
    if (!instance_exists(carried_player)) exit;
    if (!variable_instance_exists(carried_player, "carried_by") || carried_player.carried_by != id) exit; // we lost ownership
    if (!instance_exists(other)) exit; // enemy already gone

    // read enemy value safely (default 0)
    var enemy_val = variable_instance_exists(other, "value") ? other.value * random_range(0.8,1.2) : 0;
	var crit = false
	if (random_range(0,100) > 90) crit = true

    // award points to the carried player (or global fallback)
    if (variable_instance_exists(carried_player, "points")) {
        carried_player.points += enemy_val;
    } else {
        if (!variable_global_exists("points")) global.points = 0;
        global.points += enemy_val;
    }

    // create points popup at enemy location (capture coords first)
    var ex = other.x;
    var ey = other.y;
    var pop = instance_create_layer(ex, ey, "Splash", oPointsPop);
    if (pop != noone) 
	{
		pop.amount = enemy_val;
		pop.is_critical = crit
	}
	
	
	

    // destroy the enemy (its Destroy event runs normally)
    with (other) {
        // run any local death VFX if you like, e.g. spawn_block_gibs() if defined
        instance_destroy();
    }
}