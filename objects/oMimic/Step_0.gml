// Inherit the parent event
event_inherited();

//jump
if (frameCount mod jumpInterval == 0)
{
	vsp -= 6
	var lay = layer; 
    instance_create_layer(x, bbox_bottom - 3, lay, oPoof);
}