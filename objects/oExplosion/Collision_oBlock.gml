// oExplosion Collision with oBlock
if (!active) exit;
if (!instance_exists(other)) exit;

// prevent double-award
if (!variable_instance_exists(other,"collected") || !other.collected) {
    other.collected = true;

    if (variable_instance_exists(other,"value") && other.value > 0) {
        var val = other.value;

        if (instance_exists(owner_player) && variable_instance_exists(owner_player,"points"))
            owner_player.points += val;
        else {
            if (!variable_global_exists("points")) global.points = 0;
            global.points += val;
        }

        // popup (use depth or your UI layer)
        var pop = instance_create_depth(other.x, other.y, -100, oPointsPop);
        if (pop != noone) pop.amount = val;
    }

    with (other) {
        if (variable_global_exists("World") && !is_undefined(global.World)) {
            var c = variable_instance_exists(id,"gcol") ? gcol : world_px_to_col(x);
            var r = variable_instance_exists(id,"grow") ? grow : world_py_to_row(y);
            world_on_tile_instance_mark_air(c, r);
        }
        instance_destroy();
    }
}