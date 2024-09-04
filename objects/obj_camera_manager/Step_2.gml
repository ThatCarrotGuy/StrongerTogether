/// @description Update player bounds and do the splits




//First, calculate the bounding box of all active players. 
//The results of this are used in multiple places, so we do it once here and store the result in a global. 
var p_count = instance_number(obj_player);
var min_x, max_x, min_y, max_y;
if(p_count > 0) {
	//If there are any players, build the bounding box. 
	var p1 = instance_find(obj_player, 0);
	
	//Build the base box around player 0, 
	min_x = p1.x;
	max_x = p1.x;
	min_y = p1.y;
	max_y = p1.y;
	
	//Then account for all other players (if they exist)
	for(var i = 1; i < p_count; ++i) {
		var pn = instance_find(obj_player, i); 
		min_x = min(min_x, pn.x);
		min_y = min(min_y, pn.y);
		max_x = max(max_x, pn.x);
		max_y = max(max_y, pn.y);
	}
	
	//Then update the globals so that the combined camera can use them. 
	global.player_bounds[0] = min_x;
	global.player_bounds[1] = min_y;
	global.player_bounds[2] = max_x;
	global.player_bounds[3] = max_y;
	
}
else
{
	//If there are no players, use the last values used. This is just because we use these variables later, so it's nice to have them initialized
	min_x = global.player_bounds[0];
	max_x = global.player_bounds[1];
	min_y = global.player_bounds[2];
	max_y = global.player_bounds[3];
}

//This is how many pixels away from the edge of the merged view the players have to be to cause a split. 
var border_size = 114;


//If we are in the state where views should combine (i.e, we were in splitscreen, but the players are close enough together for the combined view to reappear)
if(VIEWS_COMBINING) {
	
	//..Then we do the animation stuff. 
	
	//Make sure the combined camera is in the right place
	camera_script_both_players(CAMERA_COMBINED);
	
	//Get the current camera positions so we know how to move them
	var cam_c_x = camera_get_view_x(CAMERA_COMBINED);
	var cam_c_y = camera_get_view_y(CAMERA_COMBINED);
	
	
	var cam_p1_x = camera_get_view_x(CAMERA_P1);
	var cam_p1_y = camera_get_view_y(CAMERA_P1);
	
	var cam_p2_x = camera_get_view_x(CAMERA_P2);
	var cam_p2_y = camera_get_view_y(CAMERA_P2);
	
	
	//BONUS: Arbitrary time limit is moved here so it can be used with lerp_rate
	var arbitrary_time_limit = 45;
	
	//BONUS: Lerp rate is affected by the arbitrary time limit so that the views are always in the right place on merge. 
	var lerp_rate = lerp(0.2, 1, sqr(VIEWS_COMBINING_TIMER/arbitrary_time_limit));
	
	//Move the top-screen camera toward where the combined view is 
	cam_p1_x = lerp(cam_p1_x, cam_c_x, lerp_rate);
	cam_p1_y = lerp(cam_p1_y, cam_c_y, lerp_rate);
	
	//Move the lower screen camera to where the combined view is - this uses a bit more math to position it in the right place relative to the combined view
	cam_p2_x = lerp(cam_p2_x, cam_c_x, lerp_rate);
	var cam_p2_target_y = cam_c_y + camera_get_view_height(CAMERA_COMBINED) - camera_get_view_height(CAMERA_P2);
	cam_p2_y = lerp(cam_p2_y, cam_p2_target_y, lerp_rate);
	
	//Update the cameras with the new positions. 
	camera_set_view_pos(CAMERA_P1, cam_p1_x, cam_p1_y);
	camera_set_view_pos(CAMERA_P2, cam_p2_x, cam_p2_y);
	
	//The is the squared distance that the views should be less than to cause a merge. If this is not met in time, the VIEWS_COMBINING_TIMER will ensure that the views don't get "stuck"
	var threshold = 0.25;
	
	
	
	
	//if players are diverging, split em back up. 
	if(((max_x - min_x) > (camera_get_view_width(CAMERA_COMBINED) - 2 * border_size)
			|| (max_y - min_y) > (camera_get_view_height(CAMERA_COMBINED) - 2 * border_size)))
	{
		//Reset certain values and make sure the cameras can update properly again. 
		VIEWS_COMBINING = false;
		VIEWS_COMBINING_TIMER = 0;
		camera_set_update_script(CAMERA_P1, camera_script_individual_players);
		camera_set_update_script(CAMERA_P2, camera_script_individual_players);
		
	}
	//If it takes too long to recombine, force it
	//Or if both views are close to destination, recombined
	else if((VIEWS_COMBINING_TIMER > arbitrary_time_limit)
		|| ((sqr(cam_p1_x - cam_c_x) + sqr(cam_p1_y - cam_c_y) < threshold)
			&& (sqr(cam_p2_x - cam_c_x) + sqr(cam_p2_y - cam_p2_target_y) < threshold)))
	{
		//Hide the split views and show the combined view. 
		view_visible[0] = true;
		view_visible[1] = false;
		view_visible[2] = false;
		//Reset values and re-set scripts. 
		VIEWS_COMBINING = false;
		VIEWS_COMBINING_TIMER = 0;
		camera_set_update_script(CAMERA_P1, camera_script_individual_players);
		camera_set_update_script(CAMERA_P2, camera_script_individual_players);
	}
	
	//Increase the timer so that the game doesn't try to merge the views without success forever
	++VIEWS_COMBINING_TIMER;
}
else {
	//If the players are too far apart....
	if((max_x - min_x) > (camera_get_view_width(CAMERA_COMBINED) - 2 * border_size)
		|| (max_y - min_y) > (camera_get_view_height(CAMERA_COMBINED) - 2 * border_size)) {
		
		//and the combined view is still visible
		if(view_visible[0]) {
			//Hide the combined view and show the splitscreen views. 
			view_visible[0] = false;
			view_visible[1] = true;
			view_visible[2] = true;
			
			
		
			//Make cameras swap the targets if the top target is further down. Makes the transistion less jarring. 
			//view_targets 1 and 2 are both the players. Hardcoding this is kinda bad, but it works for now. 
			//This is optional, and may want to be user configurable. 
			if(instance_exists(global.view_targets[1]) && instance_exists(global.view_targets[2])){
				if(global.view_targets[1].y > global.view_targets[2].y) {
					var tmp = global.view_targets[1];
					global.view_targets[1] = global.view_targets[2];
					global.view_targets[2] = tmp;
				}
			}
			
			//Set the camera view positions to be relative to te combined view. 
			var cam_c_x = camera_get_view_x(CAMERA_COMBINED);
			var cam_c_y = camera_get_view_y(CAMERA_COMBINED);
			
			camera_set_view_pos(CAMERA_P1, cam_c_x, cam_c_y);
			camera_set_view_pos(CAMERA_P2, cam_c_x, cam_c_y + camera_get_view_height(CAMERA_COMBINED) - camera_get_view_height(CAMERA_P2));
			
			
		}
	}
	else {
		//Because of the VIEWS_COMBINING condition, the check for the visibilty of view[0] was no longer needed. 
			
		//This makes sure the position of the combined camera is in the right place, because it won't move automatically while view[0] is invisible. 
		camera_script_both_players(CAMERA_COMBINED, 1);
		
		//The update scripts for these cameras are disabled so they don't fight with the combining animation. 
		camera_set_update_script(CAMERA_P1, -1);
		camera_set_update_script(CAMERA_P2, -1);
		
		//This is flagged true to tell the game the views are merging into one, so don't do any weird updates. 
		VIEWS_COMBINING = true;
			
		
	}
}
	
