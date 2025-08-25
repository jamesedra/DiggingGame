//xVelocity = 0
yVelocity += 0.1

//LEFT AND RIGHT MOVEMENT-------
moved = false;
if keyboard_check(ord("A"))
{
	moved = true;
	if (abs(xVelocity - xAccel) < xVelocityMax)
	{
		xVelocity = xVelocity - xAccel
		
	}
}

if keyboard_check(ord("D"))
{
	moved = true;
	if (abs(xVelocity + xAccel) < xVelocityMax)
	{
		xVelocity = xVelocity + xAccel
	}
}

if (!moved)
{
	if (xVelocity > 0.0)
	{
		xVelocity -= xDeAccel
		if (xVelocity < 0.0)
		{
			xVelocity = 0.0
		}
	}
	else if (xVelocity < 0.0)
	{
		xVelocity += xDeAccel
		if (xVelocity > 0.0)
		{
			xVelocity = 0.0
		}
	}
}
//---------------------------

//JUMP------------------------
if place_meeting(x, y+1, oBlock_Dirt)
{
	yVelocity = 0.0
	canDoubleJump = true
	
	//jump
	if keyboard_check(vk_space)
	{
		releasedJump = false
		yVelocity = -2;
	}
}
//----------------------------------

//DOUBLE JUMP-----------------------
if keyboard_check_released(vk_space)
{
	releasedJump = true
}

if  (canDoubleJump && releasedJump && keyboard_check_pressed(vk_space))
	{
		canDoubleJump = false
		yVelocity = -2;
	}
//-------------------------------------

//MOVE PLAYER
move_and_collide(xVelocity, yVelocity, oBlock_Dirt)