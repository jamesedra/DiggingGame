/// Collision with obj_drill — robust, deterministic handling

// Only one instance should resolve the collision to avoid both sides acting.
// Use id ordering as the single-resolver: only the lower id will run the decision logic.
if (id > other) {
    // other instance will handle it
    exit;
}

// defensive early checks
if (other == noone || !instance_exists(other)) exit;

// helper: safely release a player that was attached to `p`
// (this runs in the current scope, manipulating `p` directly)
function _release_player(p) {
    if (p == noone || !instance_exists(p)) return;
    // unset carried flags so player's Step will resume naturally
    if (variable_instance_exists(p, "is_carried")) p.is_carried = false;
    if (variable_instance_exists(p, "carried_by")) p.carried_by = noone;
    if (variable_instance_exists(p, "visible")) p.visible = true;
    // restore yAccel if we saved one earlier
    if (variable_instance_exists(p, "_saved_yAccel") && p._saved_yAccel != undefined) {
        if (variable_instance_exists(p, "yAccel")) p.yAccel = p._saved_yAccel;
        p._saved_yAccel = undefined;
    } else {
        // fallback: restore a sane gravity if present
        if (variable_instance_exists(p, "yAccel")) p.yAccel = 0.1;
    }
    // zero velocities so player doesn't get flung by solver
    if (variable_instance_exists(p, "xVelocity")) p.xVelocity = 0;
    if (variable_instance_exists(p, "yVelocity")) p.yVelocity = 0;
}

// read activity state safely
var we_active    = (variable_instance_exists(id, "state") && state == "active");
var other_active = (variable_instance_exists(other, "state") && other.state == "active");

// convenience refs to carried players if any (check existence)
var our_carried   = (variable_instance_exists(id, "carried_player")   ? carried_player   : noone);
var other_carried = (variable_instance_exists(other, "carried_player") ? other.carried_player : noone);

// ---------- Resolution rules ----------
// 1) If one is active and the other is not -> destroy the *non-active* drill.
// 2) If both active -> choose deterministic behavior (destroy other by default).
// 3) If both idle -> use spawn logic (random) but only resolved by this side (no race).
// Note: when destroying a drill that is carrying a player, we call _release_player on that player.

// Case: we are active, other idle -> destroy other
if (we_active && !other_active) {
    // if other had a carried player, release them first
    if (other_carried != noone && instance_exists(other_carried)) {
        _release_player(other_carried);
    }
    with (other) instance_destroy();
    exit;
}

// Case: other is active, we are idle -> destroy ourselves
if (other_active && !we_active) {
    // if we are carrying a player, release them (we'll die)
    if (our_carried != noone && instance_exists(our_carried)) {
        _release_player(our_carried);
    }
    instance_destroy(); // destroy self
    exit;
}

// Case: both active
if (we_active && other_active) {
    //// Option A (default): destroy the other one so active drills don't stack
    //if (other_carried != noone && instance_exists(other_carried)) {
    //    _release_player(other_carried);
    //}
    //with (other) instance_destroy();
    //exit;

    // Option B — STACK / TRANSFER behavior (uncomment prefer chaining):
        // If you want chaining: transfer other.carried_player to this drill
        // only if we aren't already carrying someone.
        if (our_carried == noone && other_carried != noone && instance_exists(other_carried)) {
            // take ownership of the player
            carried_player = other_carried;
            with (carried_player) {
                carried_by = id;
                // keep is_carried true; position will be updated by drill step
            }
            // then destroy the other drill (it loses its player)
            with (other) {
                carried_player = noone;
                instance_destroy();
            }
        } else {
            // fallback: destroy the other (same as above)
            if (other_carried != noone && instance_exists(other_carried)) _release_player(other_carried);
            with (other) instance_destroy();
        }
        exit;
}

// Case: both idle -> use spawn randomness but only this side decides (no race)
var r = irandom(99); // 0..99
if (r > 50) {
    // destroy other
    if (other_carried != noone && instance_exists(other_carried)) _release_player(other_carried);
    with (other) instance_destroy();
} else {
    // destroy self
    if (our_carried != noone && instance_exists(our_carried)) _release_player(our_carried);
    instance_destroy();
}
