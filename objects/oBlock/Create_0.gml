base_blend = c_white;
base_alpha = 1;
highlight_col   = c_yellow;
highlight_alpha = 0.8;

var mine_time_us = 40000 // 0.40s default
var chestValue =0



if (rotateRandom) image_angle  = 90 * irandom(3);

if (irandom_range(0,1) == 1)
{
	if (mirrorRandom) image_xscale = -1
}

//edge guide
//0: full
//1: T
//2: R
//3: B
//4: L
//5: TR
//6: RB
//7: LB
//8: TL
//9: LTR
//10: TRB
//11: LBR
//12: TLB