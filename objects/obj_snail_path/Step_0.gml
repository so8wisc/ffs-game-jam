//Passage # includes zero (zero is first)
with (obj_battle){
	current_passage = next_passage;
	passage_text = global.battle_snail[current_passage, 0];
	switch (current_passage) {
		case 0: {
			//
			switch (roll_option) {
				case 0: {
					next_passage = 1;
					break;
				}
				case 1: {
					next_passage = 2;
					break;
				}
			}
			break;
		}
			
	}
}