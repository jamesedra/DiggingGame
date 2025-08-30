var t = clamp((playerInstance.y) / max(1, room_height), 0, 1);
fx_set_parameter(colour_fx, "g_Intensity", t);