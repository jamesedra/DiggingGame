// oWalkDust : CREATE  (pixel-art style)
life  = irandom_range(10, 14);
age   = 0;

// if spawner didn't set, give sensible defaults
if (!variable_instance_exists(id, "col"))  col  = make_color_rgb(190, 180, 160);

// small cluster of square chips
chips_n   = irandom_range(3, 5);
chip_offx = [];  // per-chip local offsets from spawn
chip_offy = [];
chip_hsp  = [];  // integer pixel speeds (no subpixel blur)
chip_vsp  = [];
chip_sz   = [];  // pixel size per chip (1–3px)

for (var i = 0; i < chips_n; ++i) {
    chip_offx[i] = irandom_range(-1, 1);
    chip_offy[i] = -irandom(1);      // start slightly above ground
    chip_hsp[i]  = irandom_range(-1, 1); // -1, 0, or +1 px/frame
    chip_vsp[i]  = -irandom(1);         //  0 or -1 px/frame (drift up)
    chip_sz[i]   = choose(1,1,2,2,3);   // bias toward small
}

// 3-step palette from darker -> base -> lighter (solid, no alpha fade)
col_step0 = merge_color(c_black, col, 0.75);
col_step1 = col;
col_step2 = merge_color(c_white, col, 0.50);

// update every other frame so motion stays subtle
tick_every = 2;
