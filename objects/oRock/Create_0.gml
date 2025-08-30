// Inherit the parent event
event_inherited();

// 98% sRock (196/200), remaining 2% split evenly (1/200 each)
var roll = irandom(199); // 0..199 inclusive

if (roll < 196) {
	//normal sprite
}
else if (roll < 197) {
    sprite_index = sRock_Bone;  value = 60;
}
else if (roll < 198) {
    sprite_index = sRock_Fish;  value = 60;
}
else if (roll < 199) {
    sprite_index = sRock_Skull; value = 60;
}
else { // roll == 199
    sprite_index = sRock_Skull2; value = 60;
}

