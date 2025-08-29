/// @func spawn_block_gibs(pieces)
/// @desc Slices this instance's sprite into pieces×pieces and spawns oGib for each slice.
function spawn_block_gibs(pieces)
{
    var spr = sprite_index;
    var sub = image_index;
    var ow  = sprite_get_xoffset(spr);
    var oh  = sprite_get_yoffset(spr);
    var tw  = sprite_get_width(spr);
    var th  = sprite_get_height(spr);

    var cols = max(1, pieces);
    var rows = max(1, pieces);

    // base cell size (integers)
    var cw  = tw div cols;
    var ch  = th div rows;

    var lay = layer_get_id("FX_Gibs");
	if (lay == -1) {
	    // fallback: make one in front of the block layer
	    lay = layer_create(layer_get_depth(layer) - 1000);
	    layer_set_name(lay, "FX_Gibs");
	}

    for (var gy = 0; gy < rows; gy++)
    for (var gx = 0; gx < cols; gx++)
    {
        // last row/col take the remainder so we cover 100% of the sprite
        var sx = gx * cw;
        var sy = gy * ch;
        var sw = (gx == cols - 1) ? (tw - cw * (cols - 1)) : cw;
        var sh = (gy == rows - 1) ? (th - ch * (rows - 1)) : ch;

        var d = instance_create_layer(x, y, lay, oGib);
        d.spr     = spr;
        d.subimg  = sub;
        d.src_x   = sx;
        d.src_y   = sy;
        d.src_w   = sw;
        d.src_h   = sh;
        d.orig_xo = ow;
        d.orig_yo = oh;

        // Kick pieces outward from where they are in the block
        var cx = (sx + sw * 0.5) - ow;
        var cy = (sy + sh * 0.5) - oh;
        var dir = point_direction(0, 0, cx, cy) + random_range(-18, 18);
        var spd = random_range(1.2, 5.0);

        d.hsp = lengthdir_x(spd, dir) + random_range(-0.6, 0.6);
        d.vsp = lengthdir_y(spd, dir) + random_range(-0.6, 0.6);
    }
}

/// @function spawn_biscuit_burst(x, y, spr_biscuit, count, layer_id_or_name)
function spawn_biscuit_burst(_x, _y, _count) {
    var lay = layer_get_id("FX_Gibs");

    repeat (_count) {
        var bx = _x + random_range(-3, 3);
        var by = _y + random_range(-3, 3);
        var inst = instance_create_layer(bx, by, lay, oBiscuitGib);

        // Optionally override motion for more radial “pop”
        var spd = random_range(2.6, 4.6);
        var dir = irandom(359);
        inst.vx  = lengthdir_x(spd, dir);
        inst.vy  = lengthdir_y(spd, dir) - random_range(0.8, 1.8);
        inst.life_s = random_range(0.55, 0.9);
        inst.spin_deg = irandom_range(-14, 14);
    }
}

/// @func spawn_block_gibs_explosive(pieces, boom_mult)
/// @desc Like spawn_block_gibs, but scales velocity / chaos / airtime by boom_mult (>=1).
function spawn_block_gibs_explosive(pieces, boom_mult)
{
    boom_mult = max(1, real(boom_mult)); // safety

    var spr = sprite_index;
    var sub = image_index;
    var ow  = sprite_get_xoffset(spr);
    var oh  = sprite_get_yoffset(spr);
    var tw  = sprite_get_width(spr);
    var th  = sprite_get_height(spr);

    var cols = max(1, pieces);
    var rows = max(1, pieces);

    var cw  = tw div cols;
    var ch  = th div rows;

    var lay = layer_get_id("FX_Gibs");
    if (lay == -1) {
        lay = layer_create(layer_get_depth(layer) - 1000);
        layer_set_name(lay, "FX_Gibs");
    }

    for (var gy = 0; gy < rows; gy++)
    for (var gx = 0; gx < cols; gx++)
    {
        var sx = gx * cw;
        var sy = gy * ch;
        var sw = (gx == cols - 1) ? (tw - cw * (cols - 1)) : cw;
        var sh = (gy == rows - 1) ? (th - ch * (rows - 1)) : ch;

        var d = instance_create_layer(x, y, lay, oGib);
        d.spr     = spr;
        d.subimg  = sub;
        d.src_x   = sx;
        d.src_y   = sy;
        d.src_w   = sw;
        d.src_h   = sh;
        d.orig_xo = ow;
        d.orig_yo = oh;

        // Radial push from the piece’s relative position
        var cx = (sx + sw * 0.5) - ow;
        var cy = (sy + sh * 0.5) - oh;
        var dir = point_direction(0, 0, cx, cy) + random_range(-18, 18);

        // Base speed, scaled by boom
        var base_spd = random_range(1.2, 5.0) * boom_mult;

        // Add extra chaos proportional to boom
        var jitter = 0.6 * boom_mult;

        // Kick outward + slight upward bias for “boom”
        d.hsp = lengthdir_x(base_spd, dir) + random_range(-jitter, jitter);
        d.vsp = lengthdir_y(base_spd, dir) + random_range(-jitter, jitter) - random_range(0.2, 0.8) * (boom_mult - 1);

        // Let pieces travel longer & bounce livelier as boom increases
        d.drag   = clamp(0.985 + 0.003 * min(boom_mult, 5), 0.90, 0.998); // closer to 1 = less slowdown
        d.bounce = clamp(0.35 + 0.08 * min(boom_mult, 3), 0.0, 0.8);

        // Longer lifetime on big booms
        d.life = irandom_range(20 + 6 * boom_mult, 42 + 10 * boom_mult);
    }
}
