extends Node

var current_score : int = 0
signal event_on_score_update();

func add_score(merge_name : String):
	for score_config in ConfigManager.score_section_array:
		if score_config.name == merge_name:
			current_score += score_config.score;
			event_on_score_update.emit()
			return;

func clear_score():
	current_score = 0;
	event_on_score_update.emit()
