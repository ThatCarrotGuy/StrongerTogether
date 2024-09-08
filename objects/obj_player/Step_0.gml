var horizontal = 0;
var jump = 0;
var vsp = 0;

if(PlayerIndex == 0)
{
	horizontal = keyboard_check(ord("D")) - keyboard_check(ord("A"));
	jump = keyboard_check(ord("W"));
}
else if(PlayerIndex == 1)
{
	horizontal = keyboard_check(vk_right) - keyboard_check(vk_left);
	jump = keyboard_check(vk_up);
}

var hsp = horizontal * spd;
vsp = vsp + grv;

if (place_meeting(x+hsp, y, col_obj))
{
	while(!place_meeting(x+sign(hsp), y, col_obj))
	{
		x = x + sign(hsp);
	}
	hsp = 0;
}

if (place_meeting(x+hsp, y, obj_player))
{
	while(!place_meeting(x+sign(hsp), y, obj_player))
	{
		x = x + sign(hsp);
	}
	hsp = 0;
}

x = x + hsp;

if (jump && jumps > 0)
{
	jumps = 0
	vsp = -10
}

if (place_meeting(x, y+vsp, obj_player))
{
	while(!place_meeting(x, y+sign(vsp), obj_player))
	{
		y = y + sign(vsp);
	}
	vsp = 0;
}

if (place_meeting(x, y+vsp, col_obj))
{
	while(!place_meeting(x, y+sign(vsp), col_obj))
	{
		y = y + sign(vsp);
	}
	vsp = 0;
	jumps = 1
}

y = y + vsp;

if(horizontal != 0) 
{
	image_xscale = horizontal * 2
	
	if(PlayerIndex != 0)
	{
		sprite_index = spr_player2Walk
	}
	else
	{
		sprite_index = spr_playerWalk
	}
}
else
{
	if(PlayerIndex != 0)
	{
		sprite_index = spr_player2
	}
	else
	{
		sprite_index = spr_player
	}
}