if (state == "INIT") {
	if (ds_exists(ds_messages,ds_type_list)) {
		ds_list_destroy(ds_messages);
	}
	
	if (ds_exists(ds_roll_input, ds_type_list)) {
	ds_list_destroy(ds_roll_input);
	}
	

	selected_option = 0; //which option is the arrow on
	player_turn = true;
	ds_messages = ds_list_create();
	message_counter = 0 ;//Tracks which message we're on
	show_battle_text = false; //Display battle text or not

	message_timer = 0;
	
	enemy_turn_counter = 0;
	enemy_timer = 0;
	battle_option = 0; //which option has been selected by either monster or player

	player_dead = false;
	battle = false; 
	victory = false;

	//Roll mechanic
	show_roll_options = false; //Show inner box text roll options or not
	roll_option = 0;
	
	//Dice points
	dice_points = 0;

	
	ds_roll_input = ds_list_create();
	ds_roll_input[| 0] = 1;
	ds_roll_input[| 1] = 2;
	ds_roll_input[| 2] = 3;
	ds_roll_input[| 3] = 4;
	ds_roll_input[| 4] = 5;
	ds_roll_input[| 5] = 6;

	//Screenshake

	shake_timer = 0;

	state = "READY";
}


if (battle == true) && (state == "READY"){

#region SELECT OPTION

if (player_turn) && (!show_battle_text)  {

	if (!show_roll_options) {
		if (keyboard_check_pressed(vk_down)){
			//If not the last option, go down (to next option)
			if (selected_option + 1) <= (array_length_1d(a_text) -1) {
				selected_option++;
			//Else go back to first option
			} else {
			 selected_option = 0; 
			}
			audio_play_sound(tap, 1, false);
		}

		if (keyboard_check_pressed(vk_up)) {
			//If not at top most option, go up 1 (to before option)
			if (selected_option - 1) >= 0 {
				selected_option--;
				//Else go to bottom
			} else {
				selected_option = (array_length_1d(a_text) - 1);
			}
			audio_play_sound(tap, 1, false);
		} 
				//If option is pressed
		if keyboard_check_pressed(ord("Z")) {
			message_counter = 0;
			if (!ds_exists(ds_messages, ds_type_list)){
				ds_messages = ds_list_create();
			}
			
			//Roll
			if(selected_option == 0) {
				show_roll_options = true;
			}
		
			//SPEND
			if (selected_option == 1) {
				show_roll_options = true;
			}

			//CHECK
			if (selected_option == 2) {
				check_boolean = true;
			}
			//Fourth menu option not needed, add later?
			//if (selected_option ==3) {
			//	show_heal_options = true;
			//}
		
			if (selected_option != 2) && (selected_option != 0) && (selected_option != 1){
				show_battle_text = true;
			}
			
			audio_play_sound(player_action, 1, false);
		}
	} else {
		//Show which options you can roll for
		if (show_roll_options) {
			if (keyboard_check_pressed(ord("X"))) {
				show_roll_options = false;
			}
			if (keyboard_check_pressed(vk_down)){
				//Need new system do track which passage your on
				
				//If not the last option, go down (to next option)
				if (roll_option + 1) <= (array_length_1d(a_roll_text) -1) {
					roll_option++;
				//Else go back to first option
				} else {
				 roll_option = 0; 
				}
				audio_play_sound(tap, 1, false);
			}

			if (keyboard_check_pressed(vk_up)) {
				//If not at top most option, go up 1 (to before option)
				if (roll_option - 1) >= 0 {
					roll_option--;
					//Else go to bottom
				} else {
					roll_option = (array_length_1d(a_roll_text) - 1);
				}
				audio_play_sound(tap, 1, false);
			} 
			
			if (keyboard_check_pressed(ord("Z"))) {
				message_counter = 0;
				//Make sure message lists still exist - sometimes it can be lost
				if (!ds_exists(ds_messages, ds_type_list)){
					ds_messages = ds_list_create();
				}
				//Roll for the option
				if (roll_option == 0){
					//Roll Mechanic here
					roll = scr_roll_mechanic();
					
					//After every roll lock
					if (ds_list_size(ds_roll_input) == 0) {
						scr_roll_reset();
						scr_roll_unlock_reset();
					}
				}
				//Second option
				if (roll_option == 1) {
					
				}
				//Continue Battle
				show_battle_text = true;
				show_roll_options = false;
			
			}
			
		}
	}
}

#endregion

#region MESSAGES

	//Cycle through messages
	if (show_battle_text) {
		message_timer++;
		
		if (message_timer >= time_before_button_accepted){
			if (keyboard_check_pressed(ord("Z"))) {
				//Go to next message if there is one
				if (message_counter + 1) <= (ds_list_size(ds_messages) - 1) {
					message_counter++;
				//Otherwise next actor take their turn
				} else {
					//We've shown all the messages
						if  (victory){
							battle = false; 
							//room_goto(rm_died);
							state = "INIT";
							show_battle_text = false;
						
						} else {
							if (check_boolean) {
								player_turn = true; 
								check_boolean = false;
							} else {
								player_turn = !player_turn;

							}
							show_battle_text = false;
							message_counter = 0;
							if (ds_exists(ds_messages, ds_type_list)) {
								ds_list_destroy(ds_messages);
							}
							
						}			
				}
				message_timer = 0; 
				
				//If this is an attack
				if (battle_option == 0) {
					if (!player_turn) {
						//Set screen_shake to true on condition that ds_messages is a specific messgae
						//(may not need screen shake?)
					}
				}
				
				//Play Victory Sound
				if (victory) {
					if (message_counter == 2) && (!victory_sound_played) {
						audio_play_sound(snd_victory, 1 , false);
						victory_sound_played = true;
					}
				}
			}
		}
	}		

#endregion



#region SHAKE
if (screen_shake == true) {
	shake_timer++;
	
	shakeX = irandom_range(-max_shakeX, max_shakeX);
	shakeY = irandom_range(-max_shakeY, max_shakeY);
	
	if (shake_timer >= time_til_shake_ends) {
		screen_shake = false;
		shake_timer = 0;
		shakeX = 0;
		shakeY = 0;
	}
}

#endregion


#region ENEMY TURN

if (!player_turn) && (!show_battle_text){
	enemy_timer++;
	
	if (enemy_timer >= time_til_enemy_attacks) {
		if (!ds_exists(ds_messages, ds_type_list)) {
			ds_messages = ds_list_create();
		}
		message_counter = 0
		show_battle_text = true;
		enemy_timer = 0;
		
		//Implement new system here
		ds_messages[| 0] = "Monster ATTACKS!";
		battle_option = 0;
		
		audio_play_sound(enemy_action, 1, false);
		}		
}

#endregion

}