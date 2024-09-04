function camera_script_individual_players() {


	var target = global.view_targets[view_current];
	//Make sure the target exists to minimise crash risk. 
	if(instance_exists(target)) {
		var cam = view_camera[view_current];
	
		//Offset to keep sprites in view
		var vertical_offset = -35;
	
		//Calculate the new view position, centering the view on the target. 
		var new_x = target.x - camera_get_view_width(cam) * 0.5;
		var new_y = target.y + vertical_offset - camera_get_view_height(cam) * 0.5;
	
		var lerp_rate = 0.2;
	
		//Smoothly move the camera to the new destination
		new_x = lerp(camera_get_view_x(cam), new_x, lerp_rate);
		new_y = lerp(camera_get_view_y(cam), new_y, lerp_rate);
	
		//Update the positions
		camera_set_view_pos(cam, new_x, new_y);
	
	}



}
