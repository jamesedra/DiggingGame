counter += 1;
if (counter > splash_duration) {
	global.paused = false
    instance_destroy();
}