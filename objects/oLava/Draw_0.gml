// --- oLava.Draw (world draw) ---
var vx = camera_get_view_x(cam);
var vy = camera_get_view_y(cam);
var vw = camera_get_view_width(cam);
var vh = camera_get_view_height(cam);

// Clamp fill area to the visible view
var top    = max(surface_y, vy);
var bottom = vy + vh;

// 1) Fill
// 1) Fill
if (spr_fill != noone) {
    var sw = sprite_get_width(spr_fill);
    var sh = sprite_get_height(spr_fill);

    // horizontal drift
    var t = current_time * 0.001;
    var xoff = - (scroll_x * t) mod sw;

    // start tiles at *exact* top (no snapping by sh)
    var start_x = floor((vx + xoff) / sw) * sw - xoff;
    var start_y = floor(top); // <— key change

    draw_set_alpha(1);
    draw_set_color(c_white);

    for (var xx = start_x; xx < vx + vw + sw; xx += sw) {
        for (var yy = start_y; yy < bottom + sh; yy += sh) {
            draw_sprite(spr_fill,
                        floor(image_index) mod sprite_get_number(spr_fill),
                        floor(xx), floor(yy)); // pixel snap for crispness
        }
    }
} else {
    draw_set_color(make_color_rgb(255, 60, 0));
    draw_rectangle(vx, top, vx + vw, bottom, false);
}

// 2) Surface cap (no oscillation)
if (spr_surface != noone) {
    var sw2 = sprite_get_width(spr_surface);
    var sh2 = sprite_get_height(spr_surface);

    var wave_y = surface_y; // <- no oscillation

    var start_x2 = floor(vx / sw2) * sw2;
    for (var xx2 = start_x2; xx2 < vx + vw + sw2; xx2 += sw2) {
        draw_sprite(
            spr_surface,
            floor(image_index) mod sprite_get_number(spr_surface),
            floor(xx2),
            floor(wave_y) - sh2
        );
    }
}

