extends Node

var assistive_line_enable : bool = true;
var dead_line_y : float
var save_local : SaveLocal;
var os_web : bool = false

var SAVEPATH = "user://localsave.save"
signal assistive_line_changed

func _ready():
	match OS.get_name():
		"Web":
			print ("running on web")
			os_web = true
	save_local = SaveLocal.new();
	save_local.load();
	
func set_dead_line_y(y : float):
	dead_line_y = y;
	
func game_over():
	get_tree().current_scene.process_mode = Node.PROCESS_MODE_DISABLED
	
	var score = ScoreManager.current_score;
	var top_score = ScoreManager.get_top_score()
	UIManagerCanvas.show_ui(UIManager.UI_NAMES.GameOverUI);
	
	if score > top_score :
		# replace
		var new_top_score = LeaderboardData.new(score);
		save_local.top_score = new_top_score;
		save_local.save()
	
func restart_game():
	ScoreManager.clear_score();
	get_tree().change_scene_to_file("res://scenes/game_scene.tscn")
	

func set_assistive_line_enable(enable : bool):
	assistive_line_enable = enable
	assistive_line_changed.emit()
	pass
	
