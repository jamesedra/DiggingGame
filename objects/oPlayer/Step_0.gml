//xVelocity = 0
yVelocity += yAccel
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
if place_meeting(x, y+1, oBlock)
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
move_and_collide(xVelocity, yVelocity, oBlock)

//MINE------------------------------------
// Find the one block under the mouse (topmost in depth)
var playerPos = new Vector2(x, y)
var mousePos = new Vector2(mouse_x, mouse_y)

var ray = mousePos.sub(playerPos)

var list = ds_list_create();
var n = collision_line_list(x, y, mouse_x ,mouse_y, oBlock ,true,true,list,true)
var h = (n > 0) ? list[|0] : noone; // first intersection
ds_list_destroy(list);

//check the first intersection of an oBlock from player to mouse
//h = firstIntersection

//var h = instance_position(mouse_x, mouse_y, oBlock); // 

// Cache player position once per frame
var p = instance_nearest(mouse_x, mouse_y, oPlayer);
var allow = false;

if (h != noone && p != noone)
{
    // squared distance test (no sqrt)
    var dx = h.x - p.x;
    var dy = h.y - p.y;
    allow = (dx*dx + dy*dy) <= (highlight_radius * highlight_radius);
}

// If hovered target changed, or allow-state changed, update visuals
// 1) Clear previous highlight if different
if (instance_exists(last_hover) && last_hover != h) 
{
    last_hover.image_blend = last_hover.base_blend;
    last_hover.image_alpha = last_hover.base_alpha;
}

// 2) Apply or clear highlight on current hovered
if (h != noone)
{
    if (allow)
	{
        h.image_blend = h.highlight_col;
        h.image_alpha = h.highlight_alpha;
    }
	else
	{
        h.image_blend = h.base_blend;
        h.image_alpha = h.base_alpha;
        h = noone; // treat as "nothing highlighted" if out of range
    }
}

// Track for next step
last_hover = h;


// --- HOLD TO DESTROY ---
var left_held = mouse_check_button(mb_left);
var can_mine  = (h != noone) && allow;  // re-use your hover + distance check

if (left_held && can_mine)
{
	sprite_index = sPlayer_Mine

    if (mine_target != h)
	{
        // started holding on a new block
        mine_target = h;
        mine_elapsed_us = 0;
    }
	else
	{
        // keep charging while still on the same valid block
        mine_elapsed_us += delta_time; // delta_time is microseconds
    }
}
else
{
    // released, moved off, or out of range -> reset
    mine_target = noone;
    mine_elapsed_us = 0;
	
	if (xVelocity == 0.0)
	{
		sprite_index = sPlayer_Idle
	}
	else
	{
		sprite_index = sPlayer_Walk_Right
	}
}

// break when charged long enough
if (mine_target != noone && mine_elapsed_us >= mine_target.mine_time_us) 
{
	
	show_debug_message(mine_target.mine_time_us)
    with (mine_target)
	{
	    spawn_block_gibs(6); // 4×4 = 16 pieces (try 6–8 for chunkier explosions)
	    instance_destroy();
	}

    mine_target = noone;
    last_hover = noone; // optional: clears highlight instantly
}

//mirror sprite?
if (ray.x < 0)
{
	image_xscale = -1
}
else
{
	image_xscale = 1
}

