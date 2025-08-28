// oPauseModal.Step
var dt = delta_time * 0.000001;
anim = clamp(anim + dt * 8, 0, 1);

// mouse in GUI space
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

// layout (match Draw GUI math)
var gw = display_get_gui_width();
var gh = display_get_gui_height();
var cx = gw * 0.5;
var cy = gh * 0.5;

// same pop-in scale as Draw GUI
var s  = 0.85 + (1 - power(1 - anim, 3)) * 0.15;
var ph_scaled = panel_h * s;

// fixed-size buttons (only label scales)
var bw = btn_w;
var bh = btn_h;
var total_h = bh * 2 + gap_y;                  // two buttons + gap
var group_top = cy + ph_scaled * 0.5 - total_h - margin * s;

// Continue button rect
var cont_x1 = cx - bw * 0.5;
var cont_y1 = group_top;
var cont_x2 = cont_x1 + bw;
var cont_y2 = cont_y1 + bh;

// Restart button rect
var rest_x1 = cx - bw * 0.5;
var rest_y1 = group_top + bh + gap_y;
var rest_x2 = rest_x1 + bw;
var rest_y2 = rest_y1 + bh;

// clicks
if (mouse_check_button_pressed(mb_left)) {
    if (mx >= cont_x1 && mx <= cont_x2 && my >= cont_y1 && my <= cont_y2) {
        instance_destroy(); // closes & unpauses in Destroy
        exit;
    }
    if (mx >= rest_x1 && mx <= rest_x2 && my >= rest_y1 && my <= rest_y2) {
        room_restart();
        exit;
    }
}