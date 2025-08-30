if (object_exists(oBlock) && place_meeting(x, y, oBlock)) {
    instance_destroy();
    exit;
}