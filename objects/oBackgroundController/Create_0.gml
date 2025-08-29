

colour_fx = fx_create("_filter_colourise");   // string literal is required
layer_set_fx(layer_get_id("Background_0_0"), colour_fx);                  // apply to the layer
layer_set_fx(layer_get_id("Background_0_1"), colour_fx);                  // apply to the layer
layer_set_fx(layer_get_id("Background_0_2"), colour_fx);                  // apply to the layer
layer_set_fx(layer_get_id("Background_0_3"), colour_fx);                  // apply to the layer

fx_set_parameter(colour_fx, "g_TintCol", [1,0.5,0.5,1]);
fx_set_parameter(colour_fx, "g_Intensity", 0);