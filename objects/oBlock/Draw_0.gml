draw_self()

var index = 0
var rotation = 0

if (outlineSprite == noone || outlineIndex < 0 || outlineIndex > 12)
{
	exit;
}

switch(outlineIndex)
{
	//full
	case 0:
	{
		index = 0
		rotation = 0
		break;
	}
	//1 edge
	case 1:
	{
		index = 3
		rotation = 0
		break;
	}
	case 2:
	{
		index = 3
		rotation = -90
		break;
	}
	case 3:
	{
		index = 3
		rotation = -180
		break;
	}
	case 4:
	{
		index =3
		rotation = -270
		break;
	}
	//2 edge
	case 5:
	{
		index = 2
		rotation = 0
		break;
	}
	case 6:
	{
		index = 2
		rotation = -90
		break;
	}
	case 7:
	{
		index = 2
		rotation = -180
		break;
	}
	case 8:
	{
		index = 2
		rotation = -270
		break;
	}
	//3 edge
	case 9:
	{
		index = 1
		rotation = 0
		break;
	}
	case 10:
	{
		index =1
		rotation = -90
		break;
	}
	case 11:
	{
		index =1
		rotation = -180
		break;
	}
	case 12:
	{
		index = 1
		rotation = -270
		break;
	}
}

draw_sprite_ext(
        outlineSprite,   // same sprite as the base
        index,            // the chosen frame for the overlay
        x, y,
        image_xscale, image_yscale,
        rotation,
        c_white,
        image_alpha
    );