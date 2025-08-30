// ---------- INPUT ----------
var up    = keyboard_check_pressed(vk_up)    || keyboard_check_pressed(ord("W"));
var down  = keyboard_check_pressed(vk_down)  || keyboard_check_pressed(ord("S"));
var enter = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space);

if (up)  { sel = (sel + 2) mod 3; kb_nav = true; }
if (down){ sel = (sel + 1) mod 3; kb_nav = true; }

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

// edge-to-edge gap scales with BOTH ui and btn_scale
_calc_gap = round(btn_gap_base * ui * btn_scale);

// Vertical center for the 3-button stack
_stack_cy = round(cy + stack_center_offset_y_base * ui);

// Centers at: mid, mid-(bh+gap), mid+(bh+gap)
var any_hover = false;

for (var i = 0; i < 3; i++) {
    var offset = (i - 1) * (_calc_bh + _calc_gap);
    var y_c = _stack_cy + offset;

    var x1 = round(cx - _calc_bw * 0.5);
    var y1 = round(y_c - _calc_bh * 0.5);
    var x2 = x1 + _calc_bw;
    var y2 = y1 + _calc_bh;

    bx1[i] = x1; by1[i] = y1; bx2[i] = x2; by2[i] = y2;

    if (mx >= x1 && mx <= x2 && my >= y1 && my <= y2) any_hover = true;
}

// Prefer mouse hover visuals over keyboard highlight
if (any_hover) kb_nav = false;

// ---------- CONTROLS OVERLAY INPUT ----------
if (show_controls) {
    // Aspect-correct rect for sControls centered in the panel
    var csw = max(1, sControls == noone ? 1 : sprite_get_width(sControls));
    var csh = max(1, sControls == noone ? 1 : sprite_get_height(sControls));

    var fit = min(_panel_w / csw, _panel_h / csh);
    var sc  = fit * controls_scale;

    _ctrl_w = round(csw * sc);
    _ctrl_h = round(csh * sc);
    _ctrl_x = round(_panel_x + (_panel_w - _ctrl_w) * 0.5);
    _ctrl_y = round(_panel_y + (_panel_h - _ctrl_h) * 0.5);

    // Back button (uniform scale), anchored to bottom-center of the controls sheet
    var bw = round(_calc_bw * back_btn_scale);
    var bh = round(_calc_bh * back_btn_scale);
    var bx = round(_ctrl_x + _ctrl_w * 0.5 - bw * 0.5);
    var by = round(_ctrl_y + _ctrl_h - bh - _calc_gap);

    back_x1 = bx; back_y1 = by; back_x2 = bx + bw; back_y2 = by + bh;

    // Click Back
    if (mouse_check_button_pressed(mb_left)) {
        if (mx >= back_x1 && mx <= back_x2 && my >= back_y1 && my <= back_y2) {
            show_controls = false;
			audio_play_sound(Confirm_1, 0, false)
        }
    }

    // ESC closes the overlay
    if (keyboard_check_pressed(vk_escape)) show_controls = false;

    // Skip normal menu activation while overlay is up
    exit;
}

// ---------- ACTIVATE ----------
if (enter || mouse_check_button_pressed(mb_left)) {
    var idx = sel;
    if (!enter) {
        for (var i = 0; i < 3; i++) {
            if (mx >= bx1[i] && mx <= bx2[i] && my >= by1[i] && my <= by2[i]) { idx = i; break; }
        }
    }
    var fn = buttons[idx].cb;
    if (!is_undefined(fn)) {
        if (!is_method(fn)) fn = method(self, fn);
        fn();
		 audio_play_sound(Confirm_1, 0, false)
    }
}
