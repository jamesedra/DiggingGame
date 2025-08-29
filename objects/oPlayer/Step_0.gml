// drill carry
if (is_carried) {
    // keep velocities zero while carried so they don't accumulate
    xVelocity = 0;
    yVelocity = 0;
    // optionally we could keep facing logic, but skip the rest:
    exit;
}

//xVelocity = 0
if (global.paused) exit; 
//check die

if (hp <= 0)
{
	open_try_again()
}

if (keyboard_check_pressed(ord("R")))
{
	open_pause_menu();
}

if (invuln > 0) invuln--;
image_alpha = (invuln > 0 && (invuln & 2)) ? 0.5 : 1;

// gravity
yVelocity += yAccel;

// --- Jump start based on last frame ground state ---
var was_on_ground = place_meeting(x, y + 1, oBlock);
if (was_on_ground) {
    isJumping = false;
    jump_hold_timer = 0;
    if (keyboard_check_pressed(vk_space)) {
        isJumping = true;
        jump_hold_timer = 0;
        yVelocity = -jump_initial_speed;
    }
}

// --- Variable jump height ---
if (isJumping) {
    if (keyboard_check(vk_space) && jump_hold_timer < jump_hold_time_max) {
        yVelocity -= jumpAccel;
        jump_hold_timer++;
    }
    if (keyboard_check_released(vk_space)) {
        if (yVelocity < -jump_cut_speed) yVelocity = -jump_cut_speed;
        isJumping = false;
    }
    if (yVelocity >= 0) isJumping = false; // started falling
}

// --- HORIZONTAL INPUT (A/D) ---
var left  = keyboard_check(ord("A"));
var right = keyboard_check(ord("D"));

if (left && !right) {
    xVelocity -= xAccel;
} else if (right && !left) {
    xVelocity += xAccel;
} else {
    // no input (or both pressed) -> deaccel toward 0
    if (abs(xVelocity) <= xDeAccel) {
        xVelocity = 0;
    } else {
        xVelocity -= xDeAccel * sign(xVelocity);
    }
}

// clamp to max speed
xVelocity = clamp(xVelocity, -xVelocityMax, xVelocityMax);


// --- Axis-separated move (single movement per step) ---
var hsp = xVelocity;
var vsp = yVelocity;

// Horizontal
if (hsp != 0) {
    x += hsp;
    if (place_meeting(x, y, oBlock)) {
        x -= hsp;
        var sx = sign(hsp);
        // step to contact on X only
        while (sx != 0 && !place_meeting(x + sx, y, oBlock)) x += sx;
        xVelocity = 0;
    }
}

// Vertical
if (vsp != 0) {
    y += vsp;
    if (place_meeting(x, y, oBlock)) {
        y -= vsp;
        var sy = sign(vsp);
        // step to contact on Y only
        while (sy != 0 && !place_meeting(x, y + sy, oBlock)) y += sy;
        yVelocity = 0;
    }
}

// Ground check AFTER movement (for next frame)
var on_ground = place_meeting(x, y + 1, oBlock);

if (bbox_left < 0)            { x -= bbox_left;           xVelocity = 0; } // pull inside
if (bbox_right > room_width)  { x -= (bbox_right - room_width); xVelocity = 0; }

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
	audio_play_sound(mine_target.breakSound, 0, false, 1.0)
	if (mine_target.secondaryBreakSound != noone)
	{
		audio_play_sound(mine_target.secondaryBreakSound, 0, false, 1.0)
	}
	
	//reward player if applicable
	//if (object_is_ancestor(mine_target.object_index, oChest))
	if (mine_target.value > 0)
	{
		var val = mine_target.value;
        points += val;

        // create on any instance layer; it draws in Draw GUI so layer doesn't matter
        var pop = instance_create_layer(mine_target.x, mine_target.y, "Splash", oPointsPop);
        pop.amount = val;
	}
	
    with (mine_target)
	{
	    spawn_block_gibs(8); // 4×4 = 16 pieces (try 6–8 for chunkier explosions)
		if (variable_global_exists("World") && !is_undefined(global.World)) {
		    // Prefer stored grid coords set at spawn; fall back to deriving from position
		    var c = variable_instance_exists(id, "gcol") ? gcol : world_px_to_col(x);
		    var r = variable_instance_exists(id, "grow") ? grow : world_py_to_row(y);
		    world_on_tile_instance_mark_air(c, r);
		}
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
