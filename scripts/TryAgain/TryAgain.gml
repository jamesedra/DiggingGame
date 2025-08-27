/// @function open_try_again([on_confirm])
/// @param {function|undefined} on_confirm  optional callback to run when button is pressed
function open_try_again(_on_confirm) {
    if (instance_exists(oTryAgainModel)) return; // already open

    var lay = layer_get_id("World");
    var m = instance_create_layer(0, 0, lay, oTryAgainModel);

    // default action: restart room
    if (is_undefined(_on_confirm)) {
        m.on_confirm = function() { room_restart(); };
    } else {
        m.on_confirm = _on_confirm;
    }
}
