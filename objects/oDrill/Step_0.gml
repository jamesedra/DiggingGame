// Interaction (start carry) when idle
if (state == "idle") {
    var ply = instance_nearest(x, y, oPlayer);
    if (ply != noone && point_distance(x, y, ply.x, ply.y) < 64) {
        if (keyboard_check_pressed(ord("E"))) {
            // Try to claim the player via script (atomic)
            if (SCR_Player_TryClaim(ply, id)) {
                // claim succeeded — do carry setup
                state = "active";
                sprite_index = spr_active;
                carried_player = ply;
                carry_time = 0;

                // hide / zero / save vars on the player as before
                carried_player.visible = false;

                // save and disable their "gravity-like" accel (yAccel) so they don't fall
                if (variable_instance_exists(carried_player, "yAccel")) {
                    carried_player._saved_yAccel = carried_player.yAccel;
                    carried_player.yAccel = 0;
                } else {
                    carried_player._saved_yAccel = undefined;
                }

                // zero their velocities while attached
                if (variable_instance_exists(carried_player, "xVelocity")) carried_player.xVelocity = 0;
                if (variable_instance_exists(carried_player, "yVelocity")) carried_player.yVelocity = 0;

                // (optional) debug:
                // show_debug_message("Drill " + string(id) + " claimed player " + string(carried_player));
            } else {
                // somebody else already claimed the player this frame
                // optional: play a deny sound or do nothing
            }
        }
    }
}

// Carrying logic: move up and keep player attached
if (state == "active" && carried_player != noone) {
    // sanity: if the player no longer exists, cleanup
    if (!instance_exists(carried_player)) {
        carried_player = noone;
        state = "done";
    }
    // if player is now owned by another drill, relinquish claim and cleanup
    else if (!variable_instance_exists(carried_player, "carried_by") || carried_player.carried_by != id) {
        // player is carried by someone else (lost race or was re-claimed) -> cleanup
        carried_player = noone;
        state = "done";
        sprite_index = spr_idle;
        // optional: instance_destroy(); // if you want drill gone
    }
    else {
        // safe: we actually own the player, proceed with movement
        // move the drill up
        y += carry_speed;

        // lock player position to carrier
        carried_player.x = x;
        carried_player.y = y + carry_offset_y;

        // keep velocities zero while attached (defensive)
        if (variable_instance_exists(carried_player, "xVelocity")) carried_player.xVelocity = 0;
        if (variable_instance_exists(carried_player, "yVelocity")) carried_player.yVelocity = 0;

        carry_time += 1;

        if (carry_time >= carry_duration) {
            // release sequence
            if (carried_player != noone && instance_exists(carried_player)) {
                // nudge above carrier to reduce overlap with ground
                carried_player.x = x;
                carried_player.y = y + carry_offset_y + release_nudge;
				// set player to visible
				carried_player.visible = true;

                // clear carry flags
                carried_player.is_carried = false;
                carried_player.carried_by = noone;

                // restore the player's yAccel (gravity-like) if we saved it
                if (variable_instance_exists(carried_player, "_saved_yAccel") && carried_player._saved_yAccel != undefined) {
                    carried_player.yAccel = carried_player._saved_yAccel;
                    carried_player._saved_yAccel = undefined;
                } else {
                    // if player actually has yAccel and we didn't save, restore a sane default
                    if (variable_instance_exists(carried_player, "yAccel")) carried_player.yAccel = 0.1;
                }

                // apply upward velocity so they don't immediately sink into ground
                if (variable_instance_exists(carried_player, "yVelocity")) {
                    carried_player.yVelocity = release_up_speed;
                }

                // apply horizontal push left or right, stay within player's max
                var dir = choose(-1, 1);
                if (variable_instance_exists(carried_player, "xVelocity")) {
                    var push = dir * release_push_speed;
                    // clamp to player's max if available
                    if (variable_instance_exists(carried_player, "xVelocityMax")) {
                        push = clamp(push, -carried_player.xVelocityMax, carried_player.xVelocityMax);
                    }
                    carried_player.xVelocity = push;
                }

                // done with the carried ref
                // carried_player = noone; // may need to store the player instead
            }

            // finalize drill (destroy or set to idle)
            state = "done";
            sprite_index = spr_idle;

            // destroy drill instance (if desired)
            instance_destroy();
        }
    }
}
