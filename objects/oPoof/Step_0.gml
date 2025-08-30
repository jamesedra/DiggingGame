var dt = delta_time * 0.000001; // seconds
life += dt;
if (life >= life_max) { instance_destroy(); exit; }

// move puffs
for (var i = 0; i < puffs; i++) {
    px[i] += vx[i] * dt;
    py[i] += vy[i] * dt;
    // gentle drag
    vx[i] *= 0.92;
    vy[i] *= 0.92;
}
