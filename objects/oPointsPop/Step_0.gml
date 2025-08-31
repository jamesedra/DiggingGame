// oFloatText.Step
t += (delta_time / 1_000_000) / lifetime; // delta_time is in microseconds
if (t >= 1) instance_destroy();
