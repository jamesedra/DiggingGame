/// oBiscuitGib.Step
var dt = delta_time / 1_000_000; // seconds (delta_time is microseconds)
t += dt / life_s;
if (t >= 1) { instance_destroy(); exit; }

// simple physics
vy += grav * dt * 60; // scale so it feels similar across FPS
vx *= (1 - drag * dt * 60);
x  += vx * dt * 60;
y  += vy * dt * 60;

// spin
image_angle += spin_deg * dt * 60;