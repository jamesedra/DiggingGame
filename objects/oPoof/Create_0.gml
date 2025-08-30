life     = 0;
life_max = 0.40;   // seconds on screen
puffs    = 8;      // number of squares

// overall size multiplier for each square (1.0 = current size)
poof_scale = 0.8;  // try 0.4–0.8 for smaller/chunkier puffs


// pixel look controls
pixel_size_base = 4; // size of one “pixel” block (screen px)
grid_snap       = 2; // snap everything to this grid for crisp edges

// per-puff data
px = []; py = []; vx = []; vy = []; sz = [];
for (var i = 0; i < puffs; i++) {
    // start slightly below player, with small random offset
    px[i] = irandom_range(-6, 6);
    py[i] = irandom_range(2, 8);
    // outward velocity (px/sec)
    vx[i] = irandom_range(-80, 80);
    vy[i] = irandom_range(-40, -120);
    // square size (multiplier on pixel_size_base)
    sz[i] = choose(1,1,2);
}
