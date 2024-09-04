function camera_script_both_players() {

	///@arg *camera


	var p_count = instance_number(obj_player);
	//If there are any players, we will bother running the code. You could disable this check if you want, so if players are all gone, the view will still center on their last known boundaries. 
	if(p_count > 0) {
	
		//Get the global player bounding box
		var min_x = global.player_bounds[0];
		var min_y = global.player_bounds[1];
		var max_x = global.player_bounds[2];
		var max_y = global.player_bounds[3];
	
	
		var thisCam;
		var lerp_rate = 0.2;
	
		//This allows us to apply the script directly to a camera, even if it is invisible. 
		if(argument_count > 0) {
			thisCam = argument[0];
		
			//BONUS: Allow defining the lerp value so we can put the combined camera exactly in the right place in a forced update. 
			if(argument_count > 1) {
				lerp_rate = argument[1];
			}
		}
		else {
			//This usually represents the camera running the script
			thisCam = view_camera[view_current];
		}
	
	
		//Used to keep players visually inside the view, even if their actual position is different to the sprite center. 
		var vertical_offset = -35;
	
		//Work out new positions,
		var new_x = (min_x + max_x - camera_get_view_width(thisCam)) * 0.5;
		var new_y = vertical_offset + (min_y + max_y - camera_get_view_height(thisCam)) * 0.5;
	
		//Smooth out the movement
		new_x = lerp(camera_get_view_x(thisCam),new_x, lerp_rate);
		new_y = lerp(camera_get_view_y(thisCam),new_y, lerp_rate);
	
		//and set the positions. 
		camera_set_view_pos(thisCam, new_x, new_y);
	
	
	
	}



}
