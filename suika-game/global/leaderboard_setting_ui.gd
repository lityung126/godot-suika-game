extends Control

@onready var confirm_button = $ColorRect/VBoxContainer/HBoxContainer/ConfirmButton
@onready var cancel_button = $ColorRect/VBoxContainer/HBoxContainer/CancelButton

@onready var game_id_line_edit = $ColorRect/VBoxContainer/GameIDHBoxContainer/GameIDLineEdit
@onready var api_key_line_edit = $ColorRect/VBoxContainer/APIKeyHBoxContainer/APIKeyLineEdit


var file_path = "streaming_data/settings/secret.ini"


# Called when the node enters the scene tree for the first time.
func _ready():
	confirm_button.button_up.connect(_on_confirm_button_click);
	cancel_button.button_up.connect(_on_cancel_button_click);
	

func on_enable():
	var file = FileAccess.open(file_path, FileAccess.READ);
	if file != null : 
		var config_file = ConfigFile.new();
		config_file.parse(file.get_as_text())
		game_id_line_edit.text = config_file.get_value("silentwolf", "game_id","");
		api_key_line_edit.text = config_file.get_value("silentwolf", "api_key","");
	

func _on_confirm_button_click():
	if not confirm_button.is_hovered():
		return;
	if game_id_line_edit.text.is_empty():
		printerr("game id empty")
		return
	
	if api_key_line_edit.text.is_empty():
		printerr("api key empty")
		return
	
	GameManager.ini_leaderboard(api_key_line_edit.text, game_id_line_edit.text)
	var config_file = ConfigFile.new();
	config_file.set_value("silentwolf", "game_id", game_id_line_edit.text)
	config_file.set_value("silentwolf", "api_key", api_key_line_edit.text)
	var file = FileAccess.open(file_path, FileAccess.WRITE);
	file.store_string(config_file.encode_to_text())
	file.close()
	
	UIManagerCanvas.hide_ui(UIManager.UI_NAMES.LeaderboardSettingUI);

func _on_cancel_button_click():
	if not cancel_button.is_hovered():
		return
	UIManagerCanvas.hide_ui(UIManager.UI_NAMES.LeaderboardSettingUI);
	
