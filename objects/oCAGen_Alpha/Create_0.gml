worldW = 512;
worldH = 256;
tileSize = 16;

TILE_AIR   = 0;
TILE_GRASS = 1;
TILE_DIRT  = 2;
TILE_STONE = 3;
TILE_WATER = 4;

// HELPERS
// convert pixel -> tile coords (integer)
function px_to_gx(px) { return clamp(floor(px / tileSize), 0, worldW-1); }
function py_to_gy(py) { return clamp(floor(py / tileSize), 0, worldH-1); }

// check if tile ID is considered solid for physics/collision
function is_solid_tile(gx, gy) {
    if (gx < 0 || gy < 0 || gx >= worldW || gy >= worldH) return false;
    var t = ds_grid_get(tiles, gx, gy);
    // define which tiles are solid for your gameplay
    if (t == TILE_AIR) return false;
    if (t == TILE_WATER) return false; // water is non-solid here
    if (t == TILE_LEAVES) return false; // optional
    return true;
}

/// generate_ca_and_apply(fillChance, iterations, start_offset)
// fillChance: 0..1 probability initial floor (lower -> more solid)
// iterations: smoothing passes (3..6 typical)
// start_offset: how many tiles below surface to start allowing caves (>=0)

function generate_ca_and_apply(_fillChance, _iterations, _start_offset) {
    // create temp grid
    var W = worldW, H = worldH;
    var caveGrid = ds_grid_create(W, H);

    // 1) initialize - walls by default, only allow random floor below surface+offset
    for (var gx=0; gx<W; gx++) {
        var surf = surface_heights[gx];
        for (var gy=0; gy<H; gy++) {
            if (gy < surf + _start_offset) {
                ds_grid_set(caveGrid, gx, gy, 1); // wall (no cave) above allowed carving
            } else {
                // random seed stable if you want: use hash01_local for deterministic
                ds_grid_set(caveGrid, gx, gy, (random(1) < _fillChance) ? 0 : 1);
            }
        }
    }

    // 2) smoothing passes (Moore neighborhood)
    for (var iter=0; iter < _iterations; iter++) {
        var newGrid = ds_grid_create(W, H);
        ds_grid_copy(newGrid, caveGrid);
        for (var gx=1; gx<W-1; gx++) {
            for (var gy=1; gy<H-1; gy++) {
                var wallCount = 0;
                // count 8 neighbors + self to prefer walls in edges
                for (var nx = gx-1; nx <= gx+1; nx++) {
                    for (var ny = gy-1; ny <= gy+1; ny++) {
                        if (ds_grid_get(caveGrid, nx, ny) == 1) wallCount++;
                    }
                }
                // rule: if 5 or more walls in neighborhood -> wall, else floor
                if (wallCount >= 5) ds_grid_set(newGrid, gx, gy, 1); else ds_grid_set(newGrid, gx, gy, 0);
            }
        }
        ds_grid_destroy(caveGrid);
        caveGrid = newGrid;
    }

    // 3) Optionally remove small isolated pockets (flood-fill), but we'll skip for brevity

    // 4) Apply caveGrid to tiles: only carve STONE -> AIR (so surface/dirt remain)
    var carved = 0;
    for (var gx=0; gx<W; gx++) {
        for (var gy=0; gy<H; gy++) {
            if (ds_grid_get(caveGrid, gx, gy) == 0) { // floor in caveGrid -> carve out
                if (ds_grid_get(tiles, gx, gy) == TILE_STONE) {
                    ds_grid_set(tiles, gx, gy, TILE_AIR);
                    carved++;
                }
            }
        }
    }

    ds_grid_destroy(caveGrid);
    show_debug_message("CA: carved " + string(carved) + " stone tiles into air.");
}

// create tiles grid if not already created
if (!variable_global_exists("tiles") && !variable_instance_exists(self,"tiles")) {
    tiles = ds_grid_create(worldW, worldH);
}

// SIMPLE surface heights generation (replace with your valueNoise code if you have it)
surface_heights = array_create(worldW, 0);
for (var gx = 0; gx < worldW; gx++) {
    // simple deterministic hill as placeholder
    var h = (worldH div 3) + floor(6 * sin(gx/16.0));
    h = clamp(h, 8, worldH-20);
    surface_heights[gx] = h;
}

// fill tiles with base layers so CA has STONE to carve
for (var gx=0; gx<worldW; gx++) {
    var sH = surface_heights[gx];
    for (var gy=0; gy<worldH; gy++) {
        if (gy < sH - 3) ds_grid_set(tiles, gx, gy, TILE_AIR);
        else if (gy < sH - 1) ds_grid_set(tiles, gx, gy, TILE_DIRT);
        else if (gy == sH - 1) ds_grid_set(tiles, gx, gy, TILE_GRASS);
        else ds_grid_set(tiles, gx, gy, TILE_STONE);
    }
}

generate_ca_and_apply(0.45, 4, 4);

var nonair = 0;
for (var gy=0; gy<worldH; gy++) for (var gx=0; gx<worldW; gx++) if (ds_grid_get(tiles,gx,gy) != TILE_AIR) nonair++;
show_debug_message("GENERATOR DONE | non-air=" + string(nonair) + " | surface_heights[0]=" + string(surface_heights[0]));

tile_to_object = array_create(16, noone);
tile_to_object[TILE_DIRT]  = oBlock_Dirt;
tile_to_object[TILE_GRASS] = oBlock_Dirt;
tile_to_object[TILE_STONE] = oBlock_Dirt; // optional
tile_to_object[TILE_WATER] = oBlock_Dirt; // optional

// track instances so digging can remove them
tile_instances = ds_grid_create(worldW, worldH);
for (var gx=0; gx<worldW; gx++) for (var gy=0; gy<worldH; gy++) ds_grid_set(tile_instances, gx, gy, noone);

// only spawn for the tiles that fit in the room (avoid creating entire big world)
var cols = min(worldW, room_width div tileSize);
var rows = min(worldH, room_height div tileSize);

for (var gy = 0; gy < rows; gy++) {
    for (var gx = 0; gx < cols; gx++) {
        var t = ds_grid_get(tiles, gx, gy);
        if (t == TILE_AIR) continue;
        var obj_to_create = tile_to_object[t];
        if (obj_to_create == noone) continue;
        var inst = instance_create_layer(gx*tileSize + tileSize/2, gy*tileSize + tileSize/2, "Instances", obj_to_create);
        inst.gx = gx; inst.gy = gy; inst.tile_type = t;
        ds_grid_set(tile_instances, gx, gy, inst);
    }
}
show_debug_message("DEBUG: spawned tile instances for preview area: " + string(cols) + "x" + string(rows));