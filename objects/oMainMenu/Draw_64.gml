// ---------- BACKGROUND ----------
draw_clear(make_color_rgb(12,12,20));

// ---------- PANEL ----------
if (spr_panel != noone) {
    draw_sprite_stretched_ext(spr_panel, 0, _panel_x, _panel_y, _panel_w, _panel_h, c_white, 1);
} else {
    draw_set_alpha(0.8);
    draw_set_color(make_color_rgb(20,20,36));
    draw_rectangle(_panel_x, _panel_y, _panel_x + _panel_w, _panel_y + _panel_h, false);
    draw_set_alpha(1);
}

// ---------- TITLE (near top of panel) ----------
draw_set_font(menu_font_title);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);

var title_s = 1.0 * title_scale * ui;
draw_text_transformed(_panel_x + _panel_w * 0.5, _panel_y + round(_panel_h * 0.18), title_text, title_s, title_s, 0);

// ---------- BUTTONS (use cached rects) ----------
draw_set_font(menu_font_btn);

// GUI-space mouse (already computed above, but refresh for safety)
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

for (var i = 0; i < 3; i++) {
    var x1 = bx1[i], y1 = by1[i], x2 = bx2[i], y2 = by2[i];
    var w = x2 - x1, h = y2 - y1;

    var hover   = (mx >= x1 && mx <= x2 && my >= y1 && my <= y2);
    var pressed = hover && mouse_check_button(mb_left);

    // --- Highlight colours (tint) ---
    var col_norm  = c_white;
    var col_hover = merge_colour(c_white, make_colour_rgb(255,230,120), 0.35);
    var col_press = merge_colour(c_white, make_colour_rgb(255,180, 60), 0.60);
    var col_btn   = pressed ? col_press : (hover || i == sel ? col_hover : col_norm);

    // --- Subimage choice still works if you have 0/1/2 frames in the sprite ---
    var sub = 0;
    if (spr_button != noone && sprite_get_number(spr_button) >= 3) {
        if (hover || i == sel) sub = 1;
        if (pressed)           sub = 2;
    }

    // --- Slight scale on hover/press ---
    var scale = pressed ? 0.98 : (hover || i == sel ? 1.04 : 1.00);
    var dw = round(w * scale);
    var dh = round(h * scale);
    var dx = round((x1 + x2) * 0.5 - dw * 0.5);
    var dy = round((y1 + y2) * 0.5 - dh * 0.5);

    if (spr_button != noone) {
        // Main draw with tint
        draw_sprite_stretched_ext(spr_button, sub, dx, dy, dw, dh, col_btn, 1);

        // OPTIONAL: a soft additive glow on hover (uncomment to enable)
        /*
        if (hover && !pressed) {
            gpu_set_blendmode(bm_add);
            draw_sprite_stretched_ext(spr_button, sub, dx, dy, dw, dh, col_hover, 0.25);
            gpu_set_blendmode(bm_normal);
        }
        */
    } else {
        // Fallback rectangle button
        draw_set_color(make_colour_rgb(40,40,70));
        draw_rectangle(dx, dy, dx + dw, dy + dh, false);
    }

    // --- Label (brighten slightly on hover/press) ---
    var tx = (x1 + x2) * 0.5;
    var ty = (y1 + y2) * 0.5;
    var ls = label_scale * ui;

    var label_col = (pressed || hover || i == sel)
        ? merge_colour(btn_label_color, c_white, 0.25)
        : btn_label_color;

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    if (btn_label_shadow) {
        draw_set_color(btn_shadow_color);
        draw_text_transformed(tx + btn_shadow_px, ty + btn_shadow_px, buttons[i].label, ls, ls, 0);
    }
    draw_set_color(label_col);
    draw_text_transformed(tx, ty, buttons[i].label, ls, ls, 0);
}


// ---------- RESTORE ----------
draw_set_halign(fa_left);
draw_set_valign(fa_top);
