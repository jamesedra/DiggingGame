var self_state = state;
with (other) {
	if (self_state == "active") instance_destroy();
}