if (shouldSparkle)
{
    var spawn_chance = 0.01; // 1% per step (~0.6/s at 60 FPS)
    var lifetime     = 30;   // N frames the sparkle should last
    var spr          = sSparkle; // your sparkle sprite resource

    if (random(1) < spawn_chance) {
        // Choose a layer that's above the block (fallback to current layer)
        var fx_layer = layer_get_id("FX_Gibs")

        // Create the sparkle instance at the block’s position
        var sp = instance_create_layer(x, y, fx_layer, oSparkle);
        sp.sprite_index = spr;
        sp.image_index  = 0;

        // Animate exactly once over its lifetime, then destroy via Alarm[0]
        sp.alarm[0]     = lifetime;
    }
}
