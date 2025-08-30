// oDust : DRAW  (pixel-art chips, no ternary)
draw_set_alpha(1);

// discrete stage (no smooth opacity)
var stages = 3;
var stage  = floor(age * stages / max(1, life));
stage = clamp(stage, 0, stages - 1);

// pick color without ?:
var curcol;
if (stage == 0) {
    curcol = col_step0;
} else if (stage == 1) {
    curcol = col_step1;
} else {
    curcol = col_step2;
}

draw_set_color(curcol);

var base_x = floor(x); // snap to pixels
var base_y = floor(y);

for (var i = 0; i < chips_n; ++i) {
    var px = base_x + chip_offx[i];
    var py = base_y + chip_offy[i];
    var sz = max(1, chip_sz[i] - stage); // shrink in steps

    // filled pixel-square
    draw_rectangle(px, py, px + sz - 1, py + sz - 1, false);
}

// restore defaults
draw_set_color(c_white);
draw_set_alpha(1);
