if (view_enabled) world_request_chunks_for_camera(view_camera[0], 2);

world_step_process_generation();

if (view_enabled) world_vis_build_for_camera(view_camera[0]);

if (view_enabled) world_vis_clear_outside_radius(view_camera[0], 2);

if (view_enabled) world_data_clear_outside_radius(view_camera[0], 4);
