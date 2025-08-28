function select_gem(_x, _y) {
    var W = global.World;
    // Use world rows (number of tile rows in the world)
    var h = W.rows;
    var t = _y / h * 10;          // use the function parameter, not `y`
	
    var r = random(100);
	
    if (t < 1/3) {
        if (r < 90) return W.TILE_GEMYELLOW;
        else if (r < 99) return W.TILE_GEMRED;
        else return W.TILE_GEMBLUE;
    }
    else if (t < 2/3) {
        if (r < 10) return W.TILE_GEMYELLOW;
        else if (r < 95) return W.TILE_GEMRED;
        else return W.TILE_GEMBLUE;
    }
    else {
        if (r < 1) return W.TILE_GEMYELLOW;
        else if (r < 10) return W.TILE_GEMRED;
        else return W.TILE_GEMBLUE;
    }
}
