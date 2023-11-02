extends Control

@onready var name_line_edit = $ColorRect/VBoxContainer/NameLineEdit
@onready var play_button = $ColorRect/VBoxContainer/PlayButton
@onready var setting_button = $ColorRect/VBoxContainer/SettingButton
@onready var mod_button = $ColorRect/VBoxContainer/ModButton
@onready var leaderboard_setting_button = $ColorRect/VBoxContainer/LeaderboardSettingButton

@onready var texture_rect = $ColorRect/TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	play_button.button_up.connect(_on_play_button_click)
	setting_button.button_up.connect(_on_setting_button_click)
	mod_button.button_up.connect(_on_mod_button_click)
	leaderboard_setting_button.button_up.connect(_on_leaderboard_setting_button_click)
	
	mod_button.visible = not GameManager.os_web
	leaderboard_setting_button.visible = not GameManager.os_web
	
	_load_bg();

func on_enable():
	name_line_edit.text = GameManager.save_local.player_name

func _on_play_button_click():
	GameManager.set_player_name(name_line_edit.text);
	get_tree().change_scene_to_file("res://scenes/game_scene.tscn")
	
func _on_setting_button_click():
	UIManagerCanvas.show_ui(UIManager.UI_NAMES.SettingUI);

func _on_mod_button_click():
	UIManagerCanvas.show_ui(UIManager.UI_NAMES.ModUI);

func _on_leaderboard_setting_button_click():
	UIManagerCanvas.show_ui(UIManager.UI_NAMES.LeaderboardSettingUI);

func _load_bg():
	texture_rect.texture = ResourceManager.get_texture(ConfigManager.get_menu_background_path())
