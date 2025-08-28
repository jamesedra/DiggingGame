if (state == "idle") {
    var ply = instance_nearest(x, y, oPlayer);
    if (ply != noone && point_distance(x, y, ply.x, ply.y) < 64) {
        if (keyboard_check_pressed(ord("E"))) {
            state = "active";
            sprite_index = spr_active;
            carried_player = ply;
            ply.carried_by = id;
            ply.can_control = false;
			ply.visible = false;
            carry_time = 0;
        }
    }
}

if (state == "active" && carried_player != noone) {
    // move carrier up
    y += carry_speed;

    // keep the player attached to the carrier
    carried_player.x = x;
    carried_player.y = y + carry_offset_y;

    carry_time += 1;
    if (carry_time >= carry_duration) {
        // finish carrying
        state = "done";          // or "idle" if you want it reusable
        sprite_index = spr_idle; // back to idle sprite (or use a different one)
        
        // restore player control
		carried_player.visible = true;
        carried_player.can_control = true;
        carried_player.carried_by = noone;
        carried_player = noone;
		
		// destroy drill
		instance_destroy();
    }
}