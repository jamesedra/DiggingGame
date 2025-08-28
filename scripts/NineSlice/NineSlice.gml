/// draw_nineslice1(sprite, subimg, x1,y1,x2,y2, left,top,right,bottom, col, alpha)
function draw_nineslice1(_spr, _sub, _x1, _y1, _x2, _y2, _l, _t, _r, _b, _col, _a)
{
    if (is_undefined(_spr) || _spr < 0 || !sprite_exists(_spr)) return;

    var frames = max(1, sprite_get_number(_spr));
    _sub = clamp(_sub, 0, frames - 1);

    var sw = sprite_get_width(_spr);
    var sh = sprite_get_height(_spr);

    // clamp slice margins
    _l = clamp(_l, 0, sw);
    _r = clamp(_r, 0, sw - _l);
    _t = clamp(_t, 0, sh);
    _b = clamp(_b, 0, sh - _t);

    // dest sizes
    var dst_w = max(1, _x2 - _x1);
    var dst_h = max(1, _y2 - _y1);

    // middle sizes
    var w_mid_src = max(1, sw - _l - _r);
    var h_mid_src = max(1, sh - _t - _b);
    var w_mid_dst = max(1, dst_w - _l - _r);
    var h_mid_dst = max(1, dst_h - _t - _b);

    // scale factors for mid pieces
    var sx_mid = w_mid_dst / w_mid_src;
    var sy_mid = h_mid_dst / h_mid_src;

    // ---- corners (no scaling) ----
    // TL
    draw_sprite_part_ext(_spr, _sub, 0,       0,        _l, _t, _x1,        _y1,        1, 1, _col, _a);
    // TR
    draw_sprite_part_ext(_spr, _sub, sw-_r,   0,        _r, _t, _x2 - _r,   _y1,        1, 1, _col, _a);
    // BL
    draw_sprite_part_ext(_spr, _sub, 0,       sh-_b,    _l, _b, _x1,        _y2 - _b,   1, 1, _col, _a);
    // BR
    draw_sprite_part_ext(_spr, _sub, sw-_r,   sh-_b,    _r, _b, _x2 - _r,   _y2 - _b,   1, 1, _col, _a);

    // ---- edges ----
    // Top edge (stretch X)
    draw_sprite_part_ext(_spr, _sub, _l,      0,        w_mid_src, _t,
                         _x1 + _l,  _y1,      sx_mid,   1,         _col, _a);
    // Bottom edge (stretch X)
    draw_sprite_part_ext(_spr, _sub, _l,      sh-_b,    w_mid_src, _b,
                         _x1 + _l,  _y2 - _b, sx_mid,   1,         _col, _a);
    // Left edge (stretch Y)
    draw_sprite_part_ext(_spr, _sub, 0,       _t,       _l,        h_mid_src,
                         _x1,       _y1 + _t, 1,        sy_mid,    _col, _a);
    // Right edge (stretch Y)
    draw_sprite_part_ext(_spr, _sub, sw-_r,   _t,       _r,        h_mid_src,
                         _x2 - _r,  _y1 + _t, 1,        sy_mid,    _col, _a);

    // ---- center (stretch X & Y) ----
    draw_sprite_part_ext(_spr, _sub, _l,      _t,       w_mid_src, h_mid_src,
                         _x1 + _l,  _y1 + _t, sx_mid,   sy_mid,    _col, _a);
}
