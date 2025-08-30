if (state == "active" && carried_player != noone && other != noone) {
    var target = other;

    // Ensure player's current target is valid and is the block we collided with
    if (target != noone && instance_exists(target)) {
        // Ensure the block actually has a value field before reading it
        if (variable_instance_exists(target, "value") && target.value > 0) {
            var val = target.value;

            // Add points to the carried_player if they track points, otherwise fallback to a global
            if (variable_instance_exists(carried_player, "points")) {
                carried_player.points += val;
            } else {
                if (!variable_global_exists("points")) global.points = 0;
                global.points += val;
            }
			
            // Create popup and assign amount to the local 'pop'
            var pop = instance_create_layer(target.x, target.y, "Splash", oPointsPop);
            if (pop != noone) pop.amount = val;
        }

        // Destroy the block safely (use 'with' to use same logic as player's mining)
        with (target) {
            // keep your existing break effects
            if (variable_global_exists("World") && !is_undefined(global.World)) {
                var c = variable_instance_exists(id, "gcol") ? gcol : world_px_to_col(x);
                var r = variable_instance_exists(id, "grow") ? grow : world_py_to_row(y);
                world_on_tile_instance_mark_air(c, r);
            }
            instance_destroy();
        }

        // Reset player's mine state so they don't keep referencing the destroyed block
        carried_player.mine_target = noone;
        carried_player.mine_elapsed_us = 0;
        carried_player.last_hover = noone;
    }
    else {
        // Optional: handle the case where drill hits a different block than player's target
        // Example: pick up the other block's value instead
        // (only do that if intended; keep logic explicit)
    }
}

// for creation
if (state == "idle") {
	with(other) {
		instance_destroy();
	}
}