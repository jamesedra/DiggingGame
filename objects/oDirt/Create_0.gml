event_inherited();

var r = random(100);
if (r < 96) sprite_index = sDirt4; // 80%
else if (r < 97) 
{
	sprite_index = sDirt_Bone;
	value = 50
}

else if (r < 98)
{
	sprite_index = sDirt_Skull;
	value = 50
}


else if (r < 99)
{
	sprite_index = sDirt_Skull2;
	value = 50
}

else
{
	sprite_index = sDirt_Misc;
	value = 50
}

