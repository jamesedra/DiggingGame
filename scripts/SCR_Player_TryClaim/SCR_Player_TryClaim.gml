function SCR_Player_TryClaim(){
	var _ply   = argument0;
	var _drill = argument1;

	// sanity
	if (_ply == noone || !instance_exists(_ply)) return false;

	// if player already flagged as carried, fail
	if (variable_instance_exists(_ply, "is_carried") && _ply.is_carried) {
	    return false;
	}

	// claim atomically (modify the player's fields directly)
	_ply.is_carried = true;
	_ply.carried_by = _drill;

	return true;
}