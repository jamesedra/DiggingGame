// oWalkDust : STEP
age += 1;
if (age >= life) {
    instance_destroy();
    exit;
}

// move chips on even ticks only to keep it subtle (and fully pixel-snapped)
if ((age mod tick_every) == 0) {
    for (var i = 0; i < chips_n; ++i) {
        chip_offx[i] += chip_hsp[i];
        chip_offy[i] += chip_vsp[i];

        // gentle, stepwise damping toward 0 to avoid floaty look
        if (chip_hsp[i] != 0 && irandom(2) == 0) chip_hsp[i] -= sign(chip_hsp[i]);
        if (chip_vsp[i] < 0  && irandom(2) == 0) chip_vsp[i] += 1; // drift up then settle
    }
}
