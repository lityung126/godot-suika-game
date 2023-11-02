extends Control

@onready var confirm_button = $ColorRect/VBoxContainer/HBoxContainer/ConfirmButton
@onready var cancel_button = $ColorRect/VBoxContainer/HBoxContainer/CancelButton

@onready var game_id_line_edit = $ColorRect/VBoxContainer/GameIDHBoxContainer/GameIDLineEdit
@onready var api_key_line_edit = $ColorRect/VBoxContainer/APIKeyHBoxContainer/APIKeyLineEdit


var file_path = "streaming_data/settings/secret.ini"
var config_file = ConfigFile.new();

# Called when the node enters the scene tree for the first time.
func _ready():
	confirm_button.button_up.connect(_on_confirm_button_click);
	cancel_button.button_up.connect(_on_cancel_button_click);
	

func on_enable():
	config_file.clear()
	var file = FileAccess.open(file_path, FileAccess.WRITE);
	
	

func _on_confirm_button_click():
	
	if game_id_line_edit.text.is_empty():
		printerr("game id empty")
		return
	
	if api_key_line_edit.text.is_empty():
		printerr("api key empty")
		return
	
	GameManager.ini_leaderboard(api_key_line_edit.text, game_id_line_edit.text)
	
	config_file.set_value("silentwolf", "game_id", game_id_line_edit.text)
	config_file.set_value("silentwolf", "api_key", api_key_line_edit.text)
	var file = FileAccess.open(file_path, FileAccess.WRITE);
	file.store_string(config_file.encode_to_text())
	file.close()
	
	UIManagerCanvas.hide_ui(UIManager.UI_NAMES.LeaderboardSettingUI);

func _on_cancel_button_click():
	UIManagerCanvas.hide_ui(UIManager.UI_NAMES.LeaderboardSettingUI);
	
