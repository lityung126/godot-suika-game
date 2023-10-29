extends Node

var assistive_line_enable : bool = true;
var dead_line_y : float
var save_local : SaveLocal;
var os_web : bool = false

var player_name : String;

var SAVEPATH = "user://localsave.save"
signal assistive_line_changed

var can_use_leaderboard : bool = false;

var _mod_name = "default"
var mod_name : set=_update_mod, get=_get_mod_name

func _ready():
	match OS.get_name():
		"Web":
			print ("running on web")
			os_web = true
	
	_load_leaderboard();
	save_local = SaveLocal.new();

func _update_mod(_mod_name):
	self._mod_name = _mod_name
	ConfigManager.load_config()
	AudioManager.init_from_config()
	DropManager.init_from_config()
	

func _get_mod_name():
	return _mod_name

func _load_leaderboard():
	var path = "streaming_data/settings/secret.ini";
	if GameManager.os_web:
		path = "res://" + path
	var file = FileAccess.open(path, FileAccess.READ);
	
	if file == null:
		printerr("read secret.ini fail")
	else :
		var text = file.get_as_text()
		print("read secret.ini success")
		var secret_config_file = ConfigFile.new();
		secret_config_file.parse(text)
		ini_leaderboard(
			secret_config_file.get_value("silentwolf", "api_key", ""),
			secret_config_file.get_value("silentwolf", "game_id", "")
		)
	pass
	
func ini_leaderboard(api_key : String, game_id : String):
	SilentWolf.configure({
		"api_key": api_key,
		"game_id": game_id,
		"log_level": 1
  	})
	SilentWolf.configure_scores({
		"open_scene_on_close": "res://scenes/game_scene.tscn"
	})
	if not api_key.is_empty() && not game_id.is_empty():
		can_use_leaderboard = true

func set_dead_line_y(y : float):
	dead_line_y = y;
	
func game_over():
	get_tree().current_scene.process_mode = Node.PROCESS_MODE_DISABLED
	
	var score = ScoreManager.current_score;
	var top_score = ScoreManager.get_top_score()
	UIManagerCanvas.show_ui(UIManager.UI_NAMES.GameOverUI);
	
	if score > top_score :
		# replace
		save_local.top_score = score;

	
func restart_game():
	ScoreManager.clear_score();
	get_tree().change_scene_to_file("res://scenes/game_scene.tscn")
	

func set_assistive_line_enable(enable : bool):
	assistive_line_enable = enable
	assistive_line_changed.emit()
	pass

func set_player_name(_player_name : String):
	save_local.player_name = _player_name
	if not _player_name == "":
		player_name = _player_name;
	else :
		player_name = "NoNamed"
	
