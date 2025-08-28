function select_gem(_x, _y) {
    var W = global.World;
    // Use world rows (number of tile rows in the world)
    var h = W.rows;
    var t = _y / h;          // use the function parameter, not `y`
    var r = random(100);

    if (t < 1/3) {
        if (r < 70) return W.TILE_GEMRED;
        else if (r < 95) return W.TILE_GEMYELLOW;
        else return W.TILE_GEMBLUE;
    }
    else if (t < 2/3) {
        if (r < 15) return W.TILE_GEMRED;
        else if (r < 85) return W.TILE_GEMYELLOW;
        else return W.TILE_GEMBLUE;
    }
    else {
        if (r < 5) return W.TILE_GEMRED;
        else if (r < 35) return W.TILE_GEMYELLOW;
        else return W.TILE_GEMBLUE;
    }
}
