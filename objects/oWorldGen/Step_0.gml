//if (view_enabled) world_request_chunks_for_camera(view_camera[0], 2);
//world_step_process_generation();

// request chunks for camera each frame (you already have this)
if (view_enabled) world_request_chunks_for_camera(view_camera[0], 2);

// generate a couple per frame
world_step_process_generation();

// now build visuals for any generated chunks the camera can see
if (view_enabled) {
    world_vis_build_for_camera(view_camera[0]);
    world_vis_clear_outside_radius(view_camera[0], 2); // keep visuals tight
}
