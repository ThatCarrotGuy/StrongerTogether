/// @description Set up views and cameras

//Enable the views and set default visibility
view_enabled = true;

view_visible[0] = true;
view_visible[1] = false;
view_visible[2] = false;

//Get the full width and highet of the combined view (which helps decide the sizes for the splitscreen views too)
var full_height = window_get_height();
var full_width = window_get_width();

var border_size = 2;


//Set up combined view port. 
view_set_xport(0, 0);
view_set_yport(0, 0);

view_set_wport(0, full_width);
view_set_hport(0, full_height);


//Set up the upper view
view_set_xport(1, 0);
view_set_yport(1, 0);
view_set_wport(1, full_width);

//Define how tall the two splitscreen views are
var split_view_height = (full_height - border_size) * 0.5;

view_set_hport(1, split_view_height);


//Set up the lower view
view_set_xport(2, 0);
view_set_yport(2, full_height - split_view_height);//UPDATE: This math is slightly simpler than in the video!
view_set_wport(2, full_width);
view_set_hport(2, split_view_height);

//Create and bind the camera for the combined view, also setting its update script. 
CAMERA_COMBINED = camera_create_view(0,0,full_width, full_height);
view_set_camera(0, CAMERA_COMBINED);
camera_set_update_script(CAMERA_COMBINED, camera_script_both_players);

//Create and bind the camera for the top splitscreen view, also setting its update script. 
CAMERA_P1 = camera_create_view(0,0,full_width, split_view_height);
view_set_camera(1, CAMERA_P1);
camera_set_update_script(CAMERA_P1, camera_script_individual_players);

//Create and bind the camera for the bottom splitscreen view, also setting its update script. 
CAMERA_P2 = camera_create_view(0,0,full_width, split_view_height);
view_set_camera(2, CAMERA_P2);
camera_set_update_script(CAMERA_P2, camera_script_individual_players);

//Create the view_targets array which can be used by cameras to find out who to follow. 
global.view_targets = array_create(8, noone);

//Some variables that help control the view combine animation
VIEWS_COMBINING = false;
VIEWS_COMBINING_TIMER = 0;

//This stores the bounding box of all active players - order is x1, y1, x2, y2, so similar to most rectangle functions in GameMaker. 
global.player_bounds = array_create(4);
