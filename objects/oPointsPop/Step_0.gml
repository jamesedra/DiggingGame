// oFloatText.Step
if (t == 0)
{
	if (amount >= 100)
	{
		if (is_critical)
		{
			audio_play_sound(Fruit_Collect_3, 0, false, 1.0);
		}
		else
		{
			audio_play_sound(Fruit_Collect_2, 0, false, 1.0);
		}
	}
}

t += (delta_time / 1_000_000) / lifetime; // delta_time is in microseconds
if (t >= 1) instance_destroy();
