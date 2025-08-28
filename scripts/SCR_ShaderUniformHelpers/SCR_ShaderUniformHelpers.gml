function GemGlistenUniformSetter(_r, _g, _b){
	shader_set(SH_GemGlisten);

	var t = current_time * 0.01;

	var u_time       = shader_get_uniform(SH_GemGlisten, "u_time");
	var u_speed      = shader_get_uniform(SH_GemGlisten, "u_speed");
	var u_width      = shader_get_uniform(SH_GemGlisten, "u_width");
	var u_intensity  = shader_get_uniform(SH_GemGlisten, "u_intensity");
	var u_dir        = shader_get_uniform(SH_GemGlisten, "u_dir");
	var u_maskColor  = shader_get_uniform(SH_GemGlisten, "u_maskColor");
	var u_maskTol    = shader_get_uniform(SH_GemGlisten, "u_maskTolerance");

	// Tune these to taste:
	shader_set_uniform_f(u_time, t);
	shader_set_uniform_f(u_speed, 0.001);        // slower/faster sweep
	shader_set_uniform_f(u_width, 0.002);       // band softness/width
	shader_set_uniform_f(u_intensity, 0.8);    // how white it gets
	shader_set_uniform_f(u_dir, 0.75, -0.66);  // diagonal ↘ direction (normalized)

	// Mask the red gem (loosen/tighten tolerance or disable mask by setting -1)
	shader_set_uniform_f(u_maskColor, _r, _g, _b);
	shader_set_uniform_f(u_maskTol, 0.55);     // try 0.45..0.7

	// Draw normally
	draw_self();

	// Reset
	shader_reset();
}