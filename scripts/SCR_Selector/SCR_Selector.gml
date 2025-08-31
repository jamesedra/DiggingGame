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

function select_drill(_x, _y) {
    var W = global.World;
    // Use world rows (number of tile rows in the world)
    var h = W.rows;
    var t = _y / h;
	
    var r = random(100);
	
    if (t < 1/3) {
        if (r < 90) return oDrill_Yellow;
        else if (r < 99) return oDrill_Red;
        else return oDrill_Blue;
    }
    else if (t < 2/3) {
        if (r < 10) return oDrill_Yellow;
        else if (r < 95) return oDrill_Red;
        else return oDrill_Blue;
    }
    else {
        if (r < 1) return oDrill_Yellow;
        else if (r < 10) return oDrill_Red;
        else return oDrill_Blue;
    }
}

function select_explosion() {
	var r =  random(100);
	if (r < 70) return oExplosion;
	return oExplosion_Small;
}

function select_floor_obj(_x, _y) {	
	var r = random(100);
	if (r < 50) return select_chest(_x, _y);
	else if (r < 70) return oCrystal_Blue;
	else return select_drill(_x, _y);
}

function select_ceiling_obj() {
	var r = random(100);
	if (r < 80) return oStalagmite;
	return oCrystal_Blue;
}

function select_enemy() {
	var r = random(100);
	if (r < 50) return oSlime;
	else if (r < 80) return oBat;
	else return oMimic;
}

function select_chest(_x, _y) {
    var W = global.World;
    // Use world rows (number of tile rows in the world)
    var h = W.rows;
    var t = _y / h;
	
    var r = random(100);
	
    if (t < 1/3) {
        if (r < 90) return oChest_Wood;
        else if (r < 99) return oChest_Gold;
        else return oChest_Skull;
    }
    else if (t < 2/3) {
        if (r < 10) return oChest_Wood;
        else if (r < 95) return oChest_Gold;
        else return oChest_Skull;
    }
    else {
        if (r < 1) return oChest_Wood;
        else if (r < 10) return oChest_Gold;
        else return oChest_Skull;
    }
}
