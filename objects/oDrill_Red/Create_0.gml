state = "idle"; // idle or active
spr_idle = sDrill_Red;
spr_active = sDrill_Red_Active;

sprite_index = spr_idle;

carried_player = noone;
carry_time = 0;
carry_duration = 90;      // frames to carry (1.5s at 60fps)
carry_speed = -2;         // negative Y = up
carry_offset_y = -16;     // player Y offset while attached