// Inherit the parent event
event_inherited();

var count = irandom_range(22, 40);

// spawn biscuits *before* this instance actually vanishes from the room graph
spawn_biscuit_burst(x, y, count);


