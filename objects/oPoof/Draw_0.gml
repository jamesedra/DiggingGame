// fade out & slight “expand” over time
var t = clamp(life / life_max, 0, 1);
var ease = 1 - power(1 - t, 3);
var alpha = 1 - t;

draw_set_alpha(alpha);
draw_set_color(c_white);

for (var i = 0; i < puffs; i++) {
    // snap to grid so edges are crisp and not subpixel
    var sx = round((x + px[i]) / grid_snap) * grid_snap;
    var sy = round((y + py[i]) / grid_snap) * grid_snap;

	var ps = pixel_size_base * poof_scale * sz[i] * lerp(1, 1.25, ease); // tiny growth
	ps = round(ps / grid_snap) * grid_snap; // keep size on grid too
	if (ps < grid_snap) ps = grid_snap;


    // draw a filled square “pixel”
    draw_rectangle(sx, sy, sx + ps - 1, sy + ps - 1, false);
}

draw_set_alpha(1);
