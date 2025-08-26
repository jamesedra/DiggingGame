// Defaults — tweak to taste
spr       = -1;     // source sprite (filled in when spawned)
subimg    = 0;      // frame index
src_x     = 0;      // slice top-left (pixels in the sprite)
src_y     = 0;
src_w     = 0;      // slice size
src_h     = 0;
orig_xo   = 0;      // source sprite origin
orig_yo   = 0;

hsp       = 0;      // motion
vsp       = 0;
gravity   = 0.25;
drag      = 0.985;
bounce    = 0.35;

life      = irandom_range(12, 25);
fade_tail = 10;     // last N steps fade out
image_alpha = 1;
