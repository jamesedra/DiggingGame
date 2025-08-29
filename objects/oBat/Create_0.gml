/// oEnemy_Fly : Create
event_inherited();          // run parent Create (hp, kb, etc.)

// disable gravity for flyers
grav = 0;
vsp  = 0;

// horizontal patrol speed (reuse parent wall-flip)

// bobbing params
y_home  = y;                // bobbing center; we’ll drift this toward the player
bob_amp = 16;               // px
bob_spd = 0.06;             // rad/step
bob_phi = random(2*pi);     // desync instances

// drift toward player (controls how y_home follows)
drift_gain     = 0.01;      // smoothing (0..1); higher = snappier
drift_step_max = 1.6;       // clamp per-step change (px/frame)
drift_range    = 999999;    // set to e.g. 480 if you only want drift when near
