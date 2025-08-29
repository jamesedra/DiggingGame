// Control drawing of the application surface ourselves
application_surface_draw_enable(false);

// Cache shader + uniforms
shader_fx   = SH_LavaHeat; // create this shader below
u_time      = shader_get_uniform(shader_fx, "u_time");
u_intensity = shader_get_uniform(shader_fx, "u_intensity");
