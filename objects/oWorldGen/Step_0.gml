// 1) Request: queue the chunks around the camera
if (view_enabled) {
    world_request_chunks_for_camera(view_camera[0], 2);
} else {
    // fallback if you don’t use a camera yet
    var W = global.World;
    var cols_vis = (room_width  div W.tileSize);
    var rows_vis = (room_height div W.tileSize);
    world_request_chunks_rect(0, 0, cols_vis - 1, rows_vis - 1);
}

// 2) Generate: consume the queue (N per frame)
world_step_process_generation();

// 3) Build visuals for the camera’s visible chunks
if (view_enabled) {
    world_vis_build_for_camera(view_camera[0]);
}