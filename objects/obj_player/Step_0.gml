var L_R = 0;
var U_D = 0;
var vsp = 0;
if(PlayerIndex == 0)
{
	L_R = keyboard_check(ord("D")) - keyboard_check(ord("A"));
	U_D = keyboard_check(ord("S")) - keyboard_check(ord("W"));
}
else if(PlayerIndex == 1)
{
	L_R = keyboard_check(vk_right) - keyboard_check(vk_left);
	U_D = keyboard_check(vk_down) - keyboard_check(vk_up);

	sprite_index = spr_player2;
}

var hsp = L_R * spd;
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
}

y = y + vsp;

if(L_R != 0) {
	image_xscale = L_R * 2
}
else
{
	speed = 0;
}