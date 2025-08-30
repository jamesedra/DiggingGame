counter = 0;
splash = sLoadingScreen;
splash_duration = 120;   // frames the splash is on-screen

// let GM advance frames for this instance
sprite_index = splash;
image_index  = 0;
// one full playthrough over the duration (tweak as you like)
image_speed  = 32 / room_speed;

// (optional) add a normal Draw event with nothing in it to stop auto room-space drawing
