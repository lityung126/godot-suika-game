extends Node

var dead_line_y : float

var os_web : bool = false

func _ready():
	match OS.get_name():
		"Web":
			print ("running on web")
			os_web = true
		

func set_dead_line_y(y : float):
	dead_line_y = y;
	
func game_over():
	get_tree().current_scene.process_mode = Node.PROCESS_MODE_DISABLED
	UIManagerCanvas.show_ui(UIManager.UI_NAMES.GameOverUI);

func restart_game():
	ScoreManager.clear_score();
	get_tree().change_scene_to_file("res://scenes/game_scene.tscn")

