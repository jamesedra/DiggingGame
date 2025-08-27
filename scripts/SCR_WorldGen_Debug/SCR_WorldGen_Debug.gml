// Debug draw: force-generate chunks covering the room and draw colored rects.

function world_debug_draw_room_area(_offs_px, _offs_py) {
    if (!variable_global_exists("World") || is_undefined(global.World)) {
        draw_text(8,8,"World not initialized"); return;
    }
    var W = global.World;

    // cap how much we draw (big rooms can be huge)
    var max_cols = min(room_width  div W.tileSize, 160);  // cap for perf
    var max_rows = min(room_height div W.tileSize, 90);

    draw_set_color(c_white);
    draw_text(8, 8, "Chunks queued: " + string(ds_queue_size(W.gen_queue)));

    for (var col = 0; col < max_cols; col++) {
        for (var row = 0; row < max_rows; row++) {
            var t = world_get_tile(col, row); // DO NOT create in draw
            if (is_undefined(t)) continue;    // skip not-yet-generated cells

            var clr = make_color_rgb(120,0,28); // AIR
            if (t == W.TILE_GRASS) clr = make_color_rgb(0,180,0);
            else if (t == W.TILE_DIRT)  clr = make_color_rgb(120,0,0);
            else if (t == W.TILE_STONE) clr = make_color_rgb(0,0,120);

            var px0 = _offs_px + col * W.tileSize;
            var py0 = _offs_py + row * W.tileSize;
            draw_set_color(clr);
            draw_rectangle(px0, py0, px0 + W.tileSize, py0 + W.tileSize, false);
        }
    }
}

function world_debug_draw_camera_area(_cam, _offs_px, _offs_py) {
    if (!variable_global_exists("World") || is_undefined(global.World)) { draw_text(8,8,"World not initialized"); return; }
    var W  = global.World;
    var vx = camera_get_view_x(_cam);
    var vy = camera_get_view_y(_cam);
    var vw = camera_get_view_width(_cam);
    var vh = camera_get_view_height(_cam);

    var col0 = max(0, floor(vx / W.tileSize));
    var row0 = max(0, floor(vy / W.tileSize));
    var col1 = min(W.cols - 1, floor((vx + vw - 1) / W.tileSize));
    var row1 = min(W.rows - 1, floor((vy + vh - 1) / W.tileSize));

    for (var col = col0; col <= col1; col++) {
        for (var row = row0; row <= row1; row++) {
            var t = world_get_tile(col, row);
            if (is_undefined(t)) continue; // <-- not generated yet: draw nothing

            var clr = make_color_rgb(12,18,22); // AIR default
            if (t == W.TILE_GRASS) clr = make_color_rgb(0,180,0);
            else if (t == W.TILE_DIRT)  clr = make_color_rgb(120,70,30);
            else if (t == W.TILE_STONE) clr = make_color_rgb(110,110,120);

            var px0 = _offs_px + (col * W.tileSize - vx);
            var py0 = _offs_py + (row * W.tileSize - vy);
            draw_set_color(clr);
            draw_rectangle(px0, py0, px0 + W.tileSize, py0 + W.tileSize, false);
        }
    }
}

function world_debug_draw_camera_roomspace(_cam) {
    if (!variable_global_exists("World") || is_undefined(global.World)) return;
    var W  = global.World;

    // 1) compute the tile rect the camera sees (for culling only)
    var vx = camera_get_view_x(_cam);
    var vy = camera_get_view_y(_cam);
    var vw = camera_get_view_width(_cam);
    var vh = camera_get_view_height(_cam);

    var col0 = max(0, floor(vx / W.tileSize));
    var row0 = max(0, floor(vy / W.tileSize));
    var col1 = min(W.cols - 1, floor((vx + vw - 1) / W.tileSize));
    var row1 = min(W.rows - 1, floor((vy + vh - 1) / W.tileSize));

    // 2) draw tiles at **room coords** (no -vx/-vy)
    for (var col = col0; col <= col1; col++) {
        for (var row = row0; row <= row1; row++) {
            var t = world_get_tile(col, row);
            if (is_undefined(t)) continue; // not generated yet

            var clr = make_color_rgb(12,18,22); // AIR
            if      (t == W.TILE_GRASS) clr = make_color_rgb(0,180,0);
            else if (t == W.TILE_DIRT)  clr = make_color_rgb(120,70,30);
            else if (t == W.TILE_STONE) clr = make_color_rgb(110,110,120);

            var px0 = col * W.tileSize;
            var py0 = row * W.tileSize;
            draw_set_color(clr);
            draw_rectangle(px0, py0, px0 + W.tileSize, py0 + W.tileSize, false);
        }
    }
}

/// world_debug_draw_zones_for_camera(cam)
/// Draws colored zone rectangles aligned to the world (room-space).
function world_debug_draw_zones_for_camera(_cam) {
    if (!variable_global_exists("World") || is_undefined(global.World)) return;
    var W = global.World;

    // camera view (room-space)
    var vx = camera_get_view_x(_cam);
    var vy = camera_get_view_y(_cam);
    var vw = camera_get_view_width(_cam);
    var vh = camera_get_view_height(_cam);

    // visible tiles
    var col0 = floor(vx / W.tileSize);
    var row0 = floor(vy / W.tileSize);
    var col1 = floor((vx + vw - 1) / W.tileSize);
    var row1 = floor((vy + vh - 1) / W.tileSize);

    // visible zones
    var zc0 = floor(col0 / W.zone_w);
    var zr0 = floor(row0 / W.zone_h);
    var zc1 = floor(col1 / W.zone_w);
    var zr1 = floor(row1 / W.zone_h);

    // zone pixel size
    var zpw = W.zone_w * W.tileSize;
    var zph = W.zone_h * W.tileSize;

    draw_set_alpha(0.22); // translucent fill

    for (var zc = zc0; zc <= zc1; zc++) {
        for (var zr = zr0; zr <= zr1; zr++) {
            var px0 = zc * zpw - vx;            // screen-space from room-space
            var py0 = zr * zph - vy;
            var px1 = px0 + zpw;
            var py1 = py0 + zph;

            // default: ungenerated/unknown zone
            var fill = make_color_rgb(128,128,128);
            var border = c_white;
            var label = "…";

            var key = string(zc) + "," + string(zr);
            if (ds_map_exists(W.zone_map, key)) {
                var z = ds_map_find_value(W.zone_map, key);

                if (!z.finalized) {
                    fill = make_color_rgb(90,90,90);     // dark gray = not finalized
                    label = "pending";
                } else if (z.active) {
                    // active zones: green (loot) or red (monster)
                    fill = (z.tag == W.ZONE_LOOT) ? make_color_rgb(30,180,60)
                                                  : make_color_rgb(200,60,60);
                    label = string_format(z.ratio, 0, 2) + (z.tag==W.ZONE_LOOT?" L":" M");
                } else {
                    fill = make_color_rgb(60,120,200);   // blue = inactive
                    label = string_format(z.ratio, 0, 2);
                }
            } else {
                // draw a faint grid for zones we haven't touched yet
                fill = make_color_rgb(50,50,50);
                draw_set_alpha(0.06);
            }

            draw_set_color(fill);
            draw_rectangle(px0, py0, px1, py1, false);   // outline
            draw_set_alpha(0.12);
            draw_rectangle_colour(px0, py0, px1, py1, fill, fill, fill, fill, true); // fill

            // label
            draw_set_alpha(1);
            draw_set_color(border);
            draw_text(px0 + 4, py0 + 2, label);

            // reset fill alpha for next loop
            draw_set_alpha(0.22);
        }
    }

    draw_set_alpha(1);
}
