// guard: only one side handles contact
// (make sure the player does NOT also damage itself in its Collision event)
if (other.invuln > 0) exit;

// damage + knockback
other.hp = max(0, other.hp - 1);
other.invuln   = 120;  // i-frames so this won't re-trigger immediately

// knock the player away from the enemy and pop up a bit
var away = sign(other.x - x);             // +1 if player is to the right of enemy
other.xVelocity = clamp(away * kb_mult, -5, 5);
//other.xVelocity = -2;

// tiny separation to reduce sticking
other.x += away; // nudge player 1px away

audio_play_sound(Hit_1, 0, false)
