//init
window_set_size(1920, 1080)
window_set_fullscreen(true)

//movement
xVelocity = 0.0
yVelocity = 0.0
xVelocityMax = 2.0
yVelocityMax = 4.0
xAccel = 0.2
yAccel = 0.1
xDeAccel = 0.2
canDoubleJump = true
releasedJump = true

//controller
last_hover = noone;
highlight_radius = 25; // tweak
// mining (hold) config
mine_target      = noone;
mine_time_us     = 200000; // 0.40 seconds to break (microseconds)
mine_elapsed_us  = 0;