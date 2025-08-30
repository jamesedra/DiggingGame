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

if (y + 9.6 > cave_threshold_y) crossed_cave_threshold = true
if (y + 9.6 < surface_threshold_y && crossed_cave_threshold)
{
	open_win_modal()
}

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

//tak cooldown
if (attack_cooldown > 0) attack_cooldown--;


// gravity
yVelocity += yAccel;

// --- Jump start / double jump ---
var was_on_ground = place_meeting(x, y + 1, oBlock);

if (was_on_ground) {
    // fully refresh while grounded
    jumps_remaining = max_jumps;

    isJumping = false;
    jump_hold_timer = 0;

    // ground jump
    if (keyboard_check_pressed(vk_space) && jumps_remaining > 0) {
        isJumping = true;
        jump_hold_timer = 0;
        yVelocity = -jump_initial_speed;
        jumps_remaining--; // consumed the ground jump
    }
}
else
{
    // mid-air jump (only if you still have one)
    if (keyboard_check_pressed(vk_space) && jumps_remaining > 0) {
        isJumping = true;
        jump_hold_timer = 0;
        yVelocity = -jump_initial_speed;
        jumps_remaining--; // consumed the air jump
		
		
        // spawn poof under the player
        var lay = layer; // same layer as the player
        instance_create_layer(x, bbox_bottom - 3, lay, oPoof);
    }
}

// --- Variable jump height (unchanged) ---
if (isJumping) {
    if (keyboard_check(vk_space) && jump_hold_timer < jump_hold_time_max) {
        yVelocity -= jumpAccel;
        jump_hold_timer++;
    }
    if (keyboard_check_released(vk_space)) {
        if (yVelocity < -jump_cut_speed) yVelocity = -jump_cut_speed;
        isJumping = false;
    }
    if (yVelocity >= 0) isJumping = false;
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

// If we walked off a ledge without using a ground jump, forfeit that jump
if (!on_ground && was_on_ground && jumps_remaining == max_jumps) {
    jumps_remaining = max_jumps - 1; // leaves exactly one mid-air jump
}

// (optional) refresh on landing for clarity (next frame would do it anyway)
if (on_ground) {
    jumps_remaining = max_jumps;
}


if (bbox_left < 0)            { x -= bbox_left;           xVelocity = 0; } // pull inside
if (bbox_right > room_width)  { x -= (bbox_right - room_width); xVelocity = 0; }


// --- RIGHT-CLICK ATTACK (hold to chain) ---
var right_held = mouse_check_button(mb_right);

// start an attack if we're not attacking, RMB is held, and cooldown is done
if (!is_attacking && right_held && attack_cooldown <= 0) {
    is_attacking    = true;
    attack_timer    = 0;
    attack_cooldown = attack_cooldown_max;

    // Face toward mouse on swing start
    attack_dir    = (mouse_x >= x) ? 1 : -1;
    image_xscale  = attack_dir;

    // Play attack anim
    sprite_index  = sPlayer_Attack;
    image_index   = 0;
    image_speed   = attack_image_speed;
}

// progress/finish current swing
if (is_attacking) {
    attack_timer++;
	
	
	// --- Active frames for the swing ---
// With 4 frames @ 12fps and a ~20 step swing, frames 1..2 are a good "hit" window.
var swing_active = (sprite_index == sPlayer_Attack) && (image_index >= 1) && (image_index < 3);

if (swing_active) {
    // Center the hitbox vertically on the player; push it forward based on facing
    var mid_y = (bbox_top + bbox_bottom) * 0.5;
    var y1 = mid_y - attack_hit_h * 0.5;
    var y2 = mid_y + attack_hit_h * 0.5;

    var x_front  = x + (attack_dir > 0 ? attack_hit_forward : -attack_hit_forward);
    var x1 = x_front;
    var x2 = x_front + (attack_dir > 0 ? attack_hit_w : -attack_hit_w);
	
	
    // Find enemies in the hitbox and destroy them
    var list = ds_list_create();
    var cnt  = collision_rectangle_list(x1, y1, x2, y2, oEnemy, false, true, list, false);
    if (cnt > 0) {
        // iterate and destroy
       for (var i = 0; i < cnt; ++i) {
	    var enemy = list[| i];
	    with (enemy) {
	        // take damage only if not in iframes/stun
	        if (hurt_timer <= 0) {
				if (spawned_by != noone) spawned_by.permanently_slain = true;
				slain_by_player = true;
				permanently_slain = true;
	            hp = max(0, hp - 1);

	            // knockback away from the player and pop upward a bit
	            var away = sign(x - other.x); // +1 if enemy is right of player
	            kbx = away * kb_force_x;
	            vsp = -kb_force_y;

	            // enter stun/iframes & flash red
	            hurt_timer = hit_stun_max;
	            image_blend = c_red;

	            audio_play_sound(Block_Break_3, 0, false);
				spawn_block_gibs_explosive(4, 0.25); // try 1.0 (normal) to ~3.0 (wild)
				
				if (hp <= 0) other.monsters_killed++;
	        }
	    }
}

    }
	// store debug rect (normalize so x1<x2, y1<y2)
	attack_dbg_x1 = min(x1, x2);
	attack_dbg_y1 = min(y1, y2);
	attack_dbg_x2 = max(x1, x2);
	attack_dbg_y2 = max(y1, y2);
	attack_dbg_color = (cnt > 0) ? c_lime : c_aqua; // green when a hit landed
	attack_dbg_show  = 2; // show for a couple frames so it's visible
	
    ds_list_destroy(list);
}

	
    var finished = (attack_timer >= attack_time_max) || (image_index >= image_number - 0.01);

    if (finished) {
        is_attacking = false;
        image_speed  = 1;

        // If still holding RMB: chain another swing when cooldown is done
        // (We let the normal start condition above re-trigger as soon as attack_cooldown hits 0)
        if (!right_held) {
            // not chaining - fall back to movement anim
            if (xVelocity == 0) sprite_index = sPlayer_Idle;
            else                sprite_index = sPlayer_Walk_Right;
        }
    }
}


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


// --- HOLD TO DESTROY (Terraria-style persistent progress) ---
var left_held = mouse_check_button(mb_left);
var can_mine  = (h != noone) && allow;  // existing hover+distance check

if (left_held && can_mine && !is_attacking) {
    sprite_index = sPlayer_Mine;

    if (mine_target != h) {
        // new target under the cursor; do NOT reset progress anymore
        mine_target = h;
    }

    if (instance_exists(mine_target)) {
        // accumulate progress ON THE BLOCK
        // (If you have tool power, multiply delta_time by a speed multiplier here)
        mine_target.mine_progress_us = clamp(
            mine_target.mine_progress_us + delta_time,
            0,
            mine_target.mine_time_us
        );

        // optional: mirror to a local var if your GUI expects it
        mine_elapsed_us = mine_target.mine_progress_us;
    }
} else {
    // released / moved off / out of range / attacking:
    // do NOT zero the block's progress—Terraria style keeps it.
    mine_target   = noone;
    mine_elapsed_us = 0; // purely for GUI convenience; doesn't affect block state

    if (!is_attacking) {
        if (xVelocity == 0.0) sprite_index = sPlayer_Idle;
        else                  sprite_index = sPlayer_Walk_Right;
    }
}

// break when the BLOCK's stored progress reaches its threshold
if (mine_target != noone && mine_target.mine_progress_us >= mine_target.mine_time_us) {
    // reward player if applicable
    if (mine_target.value > 0) {
        var val = mine_target.value;
        points += val;
        var pop = instance_create_layer(mine_target.x, mine_target.y, "Splash", oPointsPop);
        pop.amount = val;
    }

    with (mine_target) {
        if (variable_global_exists("World") && !is_undefined(global.World)) {
            var c = variable_instance_exists(id, "gcol") ? gcol : world_px_to_col(x);
            var r = variable_instance_exists(id, "grow") ? grow : world_py_to_row(y);
            world_on_tile_instance_mark_air(c, r);
        }
        instance_destroy();
        other.blocks_mined += 1;
    }

    mine_target = noone;
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

//update stats
max_depth = max(max_depth, y)