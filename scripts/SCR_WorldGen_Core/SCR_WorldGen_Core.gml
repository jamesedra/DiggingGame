function world_px_to_col(_px) {
	var W = global.World;
	return clamp(floor(_px / W.tileSize), 0, W.cols - 1);
}

function world_py_to_row(_py) {
    var W = global.World;
    return clamp(floor(_py / W.tileSize), 0, W.rows - 1);
}

function world_worldcol_to_chunkcol(_col) {
    var W = global.World;
    return floor(_col / W.chunk_w);
}
function world_worldrow_to_chunkrow(_row) {
    var W = global.World;
    return floor(_row / W.chunk_h);
}

function world_chunk_key(_ccol, _crow) {
    return string(_ccol) + "," + string(_crow);
}

// deterministic 0..1 hash (don’t touch RNG)
function world_hash01(_ix, _iy, _seed) {
    var nVal = (_ix * 73856093) ^ (_iy * 19349663) ^ (_seed * 83492791);
    return frac(sin(nVal) * 43758.5453);
}

// 1D value noise (0..1)
function world_valueNoise1D(_p, _freq, _octaves, _seed) {
    var amp    = 1.0;
    var maxAmp = 0.0;
    var sum    = 0.0;
    var f      = 1.0;

    for (var o = 0; o < _octaves; o++) {
        // coordinate at this octave
        var coord = _p * _freq * f;
        var xi    = floor(coord);
        var t     = coord - xi;             // 0..1 within the cell

        t = t * t * (3 - 2 * t); // smoothstep

        // hash at lattice points
        var v0 = world_hash01(xi,     0, _seed + o * 101);
        var v1 = world_hash01(xi + 1, 0, _seed + o * 101);

        // interpolate
        var v = lerp(v0, v1, t);

        sum    += v * amp;
        maxAmp += amp;
        amp    *= 0.5;
        f      *= 2.0;
    }

    return (maxAmp > 0.0) ? (sum / maxAmp) : 0.0;
}