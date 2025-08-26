// simple motion + ground bounce
vsp += gravity;
hsp *= drag;

x += hsp;
y += vsp;

if (place_meeting(x, y + 1, oBlock)) {
    // crude bounce; replace with your own collision if you like
    y = yprevious;
    vsp = -vsp * bounce;
    hsp *= 0.8;
}

// lifetime & fade
life--;
if (life <= fade_tail) {
    image_alpha = max(0, life / max(1, fade_tail));
}
if (life <= 0) instance_destroy();
