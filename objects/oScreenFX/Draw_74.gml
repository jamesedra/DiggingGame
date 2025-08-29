if (!surface_exists(application_surface)) exit;

var w = display_get_gui_width();
var h = display_get_gui_height();
var ii = clamp(variable_global_exists("lava_fx") ? global.lava_fx : 0, 0, 1);

if (ii > 0.001) {
    shader_set(shader_fx);
    shader_set_uniform_f(u_time, current_time * 0.001);
    shader_set_uniform_f(u_intensity, ii);
    draw_surface_stretched(application_surface, 0, 0, w, h);
    shader_reset();
} else {
    draw_surface_stretched(application_surface, 0, 0, w, h);
}
