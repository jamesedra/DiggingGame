/// @function open_pause_menu([on_resume], [on_restart])
/// @param {function|undefined} on_resume   optional callback when continuing
/// @param {function|undefined} on_restart  optional callback when restarting
function open_pause_menu(_on_resume, _on_restart) {
    if (instance_exists(oPauseModel)) return; // already open

    var lay = layer_get_id("World");
    var m   = instance_create_layer(0, 0, lay, oPauseModel);

    // optional callbacks
    if (!is_undefined(_on_resume))  m.on_resume  = _on_resume;
    if (!is_undefined(_on_restart)) m.on_restart = _on_restart;
}
