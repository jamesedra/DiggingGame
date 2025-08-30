// don't hurt the player while we're in hitstun
if (hurt_timer > 0) exit;

// (rest of your existing collision code)
if (other.invuln > 0) exit;
other.hp = max(0, other.hp - 1);
other.invuln = 120;

// --- ALWAYS-ON 2D KNOCKBACK (X + Y) ---
var dx  = other.x - x;
var dy  = other.y - y;
var len = max(1, sqrt(dx*dx + dy*dy));

// normalized "away from enemy" vector
var nx = dx / len;
var ny = dy / len;

// perfect overlap fallback (rare)
if (dx == 0 && dy == 0) {
    nx = (image_xscale == 0) ? 1 : image_xscale; // face dir if possible
    ny = -1; // nudge upward a bit
}

// X knockback (uses your kb_mult, same clamp range as before)
var kx = clamp(nx * kb_mult, -5, 5);
if (variable_instance_exists(other, "xVelocity")) {
    other.xVelocity = kx;
} else if (variable_instance_exists(other, "hsp")) {
    other.hsp = kx;
} else {
    other.x += sign(nx); // minimal separation if no X vel var
}

// Y knockback (uses your kb_force_y; upward when player is above)
var ky = clamp(ny * kb_force_y, -2, 2);
if (variable_instance_exists(other, "yVelocity")) {
    other.yVelocity = ky;
} else if (variable_instance_exists(other, "vsp")) {
    other.vsp = ky;
} else {
    other.y += sign(ny); // minimal separation if no Y vel var
}

// small extra separation so they don't stick
other.x += sign(nx);
other.y += sign(ny);

audio_play_sound(Hit_1, 0, false);

var lay = layer; 
instance_create_layer(x, bbox_bottom - 3, lay, oPoof);
