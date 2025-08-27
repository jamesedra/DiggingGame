/// oBiscuitGib.Draw
var u = clamp(t, 0, 1);

// easing for scale (outQuad)
var e = 1 - sqr(1 - u);
var sc = lerp(scale0, scale1, e);
var a  = lerp(alpha0, alpha1, u);

// soft drop-shadow
draw_set_alpha(a * 0.6);
draw_set_color(c_black);
draw_sprite_ext(sprite_index, 0, x + 1, y + 1, sc, sc, image_angle, c_black, 1);

// main
draw_set_alpha(a);
draw_set_color(c_white);
draw_sprite_ext(sprite_index, 0, x, y, sc, sc, image_angle, c_white, 1);

// restore
draw_set_alpha(1);
draw_set_color(c_white);
