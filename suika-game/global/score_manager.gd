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

func get_top_score_string() -> String:
	if GameManager.save_local.top_score == -1:
		return "-"
	else :
		return str(GameManager.save_local.top_score);
	

func get_top_score() -> int:
	return GameManager.save_local.top_score;
