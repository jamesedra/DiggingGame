// Recompute minimal geometry for hit test
var gw = display_get_gui_width();
var gh = display_get_gui_height();
var cx = gw * 0.5;
var cy = gh * 0.5;

var ui_scale = min(gw/1920, gh/1080);
var s_pop = 0.85 + (1 - power(1 - anim, 3)) * 0.15;

var panel_s  = panel_scale_base  * ui_scale * s_pop;
var button_s = button_scale_base * ui_scale * s_pop;

var p_src_w = sprite_get_width(spr_panel);
var p_src_h = sprite_get_height(spr_panel);
var p_w = p_src_w * panel_s;
var p_h = p_src_h * panel_s;
var p_x = cx - p_w * 0.5;
var p_y = cy - p_h * 0.5;

var b_src_w = sprite_get_width(spr_button);
var b_src_h = sprite_get_height(spr_button);
var b_w = b_src_w * button_s;
var b_h = b_src_h * button_s;
var gap = spacing_px * panel_s;

var bx1 = p_x + (p_w - b_w) * 0.5;
var by1 = p_y + p_h - b_h - gap + (button_offset_y_base * panel_s);
var bx2 = bx1 + b_w;
var by2 = by1 + b_h;

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

// mouse click
if (mouse_check_button_pressed(mb_left)) {
    if (mx >= bx1 && mx <= bx2 && my >= by1 && my <= by2) {
		audio_play_sound(Confirm_1, 0, false)
        room_restart()
        instance_destroy();
        exit;
    }
}
// Enter key
if (keyboard_check_pressed(vk_enter)) {
	audio_play_sound(Confirm_1, 0, false)
    if (is_method(on_confirm)) on_confirm();
    instance_destroy();
	room_restart()
}
