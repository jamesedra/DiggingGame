// ---------- INPUT ----------
var up    = keyboard_check_pressed(vk_up)    || keyboard_check_pressed(ord("W"));
var down  = keyboard_check_pressed(vk_down)  || keyboard_check_pressed(ord("S"));
var enter = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space);

if (up)   sel = (sel + 2) mod 3;
if (down) sel = (sel + 1) mod 3;

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

// ---------- GUI SCALE & CENTER ----------
gw = display_get_gui_width();
gh = display_get_gui_height();
ui = min(gw / base_w, gh / base_h);
cx = gw * 0.5;
cy = gh * 0.5;

// ---------- PANEL LAYOUT (keeps aspect) ----------
var psw = max(1, spr_panel == noone ? 1 : sprite_get_width(spr_panel));
var psh = max(1, spr_panel == noone ? 1 : sprite_get_height(spr_panel));
_panel_w = round(panel_width_base * ui * panel_scale);
_panel_h = round(_panel_w * (psh / psw));
_panel_x = round(cx - _panel_w * 0.5);
_panel_y = round(cy - _panel_h * 0.5);

// ---------- BUTTON LAYOUT (keeps aspect) ----------
var bsw = max(1, spr_button == noone ? 1 : sprite_get_width(spr_button));
var bsh = max(1, spr_button == noone ? 1 : sprite_get_height(spr_button));
_calc_bw = round(bsw * (btn_scale * ui));
_calc_bh = round(bsh * (btn_scale * ui));

// *** FIX: make the edge-to-edge gap scale with BOTH ui and btn_scale
_calc_gap = round(btn_gap_base * ui * btn_scale);

// Vertical center for the 3-button stack
_stack_cy = round(cy + stack_center_offset_y_base * ui);

// Centers at: mid, mid-(bh+gap), mid+(bh+gap)
for (var i = 0; i < 3; i++) {
    var offset = (i - 1) * (_calc_bh + _calc_gap);
    var y_c = _stack_cy + offset;

    var x1 = round(cx - _calc_bw * 0.5);
    var y1 = round(y_c - _calc_bh * 0.5);
    var x2 = x1 + _calc_bw;
    var y2 = y1 + _calc_bh;

    bx1[i] = x1; by1[i] = y1; bx2[i] = x2; by2[i] = y2;

    if (mx >= x1 && mx <= x2 && my >= y1 && my <= y2) sel = i;
}

// ---------- ACTIVATE ----------
if (enter || mouse_check_button_pressed(mb_left)) {
    var idx = sel;
    if (!enter) {
        for (var i = 0; i < 3; i++) {
            if (mx >= bx1[i] && mx <= bx2[i] && my >= by1[i] && my <= by2[i]) { idx = i; break; }
        }
    }
    var fn = buttons[idx].cb; if (is_method(fn)) fn();
}
