// don't hurt the player while we're in hitstun
if (hurt_timer > 0) exit;

// (rest of your existing collision code)
if (other.invuln > 0) exit;
other.hp = max(0, other.hp - 1);
other.invuln = 120;
var away = sign(other.x - x);
other.xVelocity = clamp(away * kb_mult, -5, 5);
other.x += away;
audio_play_sound(Hit_1, 0, false);
