// oTryAgainModal.Step
var dt = delta_time * 0.000001;
anim = clamp(anim + dt * 8, 0, 1);

// GUI mouse
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

// Layout (match Draw GUI math)
var gw = display_get_gui_width();
var gh = display_get_gui_height();
var cx = gw * 0.5;
var cy = gh * 0.5;

// same pop-in scale as Draw GUI
var s = 0.85 + (1 - power(1 - anim, 3)) * 0.15;

// Button rect: **fixed size** (no btn_scale, no s on width/height)
var ph_scaled = panel_h * s;
var bx1 = cx - (btn_w * 0.5);
var by1 = cy + ph_scaled * 0.5 - btn_h - 24 * s; // vertical spacing can still ease with s
var bx2 = bx1 + btn_w;
var by2 = by1 + btn_h;

// Click to confirm
if (mouse_check_button_pressed(mb_left)) {
    if (mx >= bx1 && mx <= bx2 && my >= by1 && my <= by2) {
        if (is_method(on_confirm)) on_confirm();		
        instance_destroy();
        exit;
    }
}

// Keyboard confirm
if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
    if (is_method(on_confirm)) on_confirm();
    instance_destroy();
}
