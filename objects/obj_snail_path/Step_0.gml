//Passage # includes zero (zero is first)
with (obj_battle){

	//We only want to begin rolling is the option is unlocked while the roll option menu is up
	//and we select it with "Z"
	if (show_roll_options) && (keyboard_check_pressed(ord("Z"))) && (!ds_options_lock[| roll_option]) {
			//Roll mechanic here
			roll = scr_roll_mechanic();
			roll_success = scr_roll_success(roll_ranges_text[roll_option], roll);
			
			passage_text = global.battle_snail[current_passage, 0];
			
			if (roll_success) {
				switch (current_passage) {
					//Start
					case 0: {
							switch (roll_option) {
								//knock knock
								case 0: {
										next_passage = 1;
										break;
	
								}
								//grab the hammer
								case 1: {
										next_passage = 2;
										break;
								
								}
							}	
						}
					
					
						break;
	
				
					//Case 2
			
				}
	
		current_passage = next_passage;
		last_lock_boolean = false;
		if (ds_exists(ds_options_lock, ds_type_list)){
			ds_list_destroy(ds_options_lock);
		}
	}
		
	}	
}