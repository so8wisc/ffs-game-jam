// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_show_controls(){
	with (obj_ui_manager) {
		// Hide main menu, show controls.
		event_user(3);	
	}
}