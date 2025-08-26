// draw this piece at the correct offset relative to the original block origin
var draw_x = x + (src_x - orig_xo);
var draw_y = y + (src_y - orig_yo);

draw_sprite_part_ext(
    spr, subimg,
    src_x, src_y, src_w, src_h,
    draw_x, draw_y,
    1, 1, c_white, image_alpha
);

// (Optional) If you want spinning pieces, use a world matrix:
//var cx = draw_x + src_w * 0.5;
//var cy = draw_y + src_h * 0.5;
//var m  = matrix_build(cx, cy, 0, 0, 0, image_angle, 1, 1, 1);
//draw_sprite_part_ext(spr, subimg, src_x, src_y, src_w, src_h, -src_w*0.5, -src_h*0.5, 1, 1, c_white, image_alpha);
//matrix_set(matrix_world, matrix_build_identity());
//image_angle += irandom_range(-6, 6) * (1 - drag); // e.g., spin in Step
